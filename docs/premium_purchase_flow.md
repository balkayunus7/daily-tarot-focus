# Premium Satin Alma Akisi

Bu dokuman Daily Tarot Focus uygulamasindaki premium satin alma akisini ve `mobile_boilerplate` icindeki purchase yapisinin nasil calistigini aciklar.

## Kisa Ozet

Uygulama premium ekranini kendi tema ve icerigiyle olusturur, ancak satin alma is mantigini `mobile_boilerplate` icindeki ortak `SubscriptionPaywallPage`, `PurchasesBloc` ve `RevenuecatPurchasesService` uzerinden yurutur.

Akisin ana kaynagi RevenueCat SDK'dir. Kullanici premium sayfasini actiginda app RevenueCat'e kullaniciyi configure eder, `premium` offering paketlerini ceker, kullanicinin secili paketi satin almasina izin verir ve basarili satin alma/restored sonucunda `AuthCubit.refetchUser()` ile backend'den kullaniciyi tekrar okur. Uygulama icinde premium olup olmama karari en son `TarotUser.subscription` / backend `premium_info` alanindan gelir.

## Ilgili Dosyalar

App tarafindaki dosyalar:

- `lib/features/core/subscription/pages/tarot_subscription_paywall_page.dart`
- `lib/features/core/subscription/premium_override_service.dart`
- `lib/features/auth/domain/models/tarot_user.dart`
- `lib/config/setup_dependieces.dart`
- `lib/config/app_config.dart`
- `lib/config/app_router.dart`
- `lib/features/tarot/presentation/tarot_spread/helpers/step6_page_mixin.dart`
- `lib/features/tarot/presentation/tarot_spread/helpers/answer_page_mixin.dart`
- `lib/features/core/settings/settings_page.dart`

Boilerplate tarafindaki dosyalar:

- `../mobile-boilerplate/lib/presentation/purchases/subscription_paywall_page.dart`
- `../mobile-boilerplate/lib/application/purchases/purchases_bloc.dart`
- `../mobile-boilerplate/lib/application/purchases/purchases_state.dart`
- `../mobile-boilerplate/lib/domain/purchases/i_purchases_service.dart`
- `../mobile-boilerplate/lib/infrastructure/purchases/revenuecat_purchases_service.dart`
- `../mobile-boilerplate/lib/domain/auth/user.dart`
- `../mobile-boilerplate/lib/domain/auth/purchaser.dart`
- `../mobile-boilerplate/lib/domain/purchases/subscription.dart`
- `../mobile-boilerplate/lib/domain/purchases/subscription_plan.dart`
- `../mobile-boilerplate/lib/domain/purchases/subscription_period.dart`

## Katmanlar

### 1. Uygulama Paywall Katmani

`TarotSubscriptionPaywallPage`, boilerplate'in generic `SubscriptionPaywallPage` widget'ini tarot uygulamasina gore konfigure eder.

Bu dosyada belirlenenler:

- Plan: `SubscriptionPlan.premium`
- Baslik ve aciklama metinleri
- Free / Pro ozellik tablosu
- Aylik paket icin "popular" badge
- Tarot renkleriyle `PaywallPageTheme`
- Header gorseli
- Paywall kapatma gecikmesi: `dismissDelay: Duration(seconds: 3)`

Bu katman satin alma is mantigini icermez. Sadece boilerplate paywall'a veri ve tema verir.

### 2. Boilerplate Paywall UI Katmani

`SubscriptionPaywallPage` ortak bir stateful paywall ekranidir.

Ekran acilinca:

1. `initState` icinde post-frame callback calisir.
2. `AuthCubit.state` uzerinden aktif kullanicinin `purchaser` bilgisi alinir.
3. `PurchasesBloc.addSubscriptionFetched(...)` dispatch edilir.
4. Paketler RevenueCat'ten gelene kadar shimmer gosterilir.
5. Kullanici paket secerse `PurchasesBloc.addPackageSelected(...)` calisir.
6. Alt butona basilinca secili paket icin `PurchasesBloc.addPackagePurchased()` calisir.

Paywall ayrica listener'larla yan etkileri yonetir:

- `isPurchasing == true`: loading overlay acar.
- Satin alma bitince loading kapanir.
- Satin alma basariliysa `AuthCubit.refetchUser()` calisir.
- Satin alma hataliysa `context.handleFailure(...)` calisir.
- Restore basariliysa yine `AuthCubit.refetchUser()` calisir.

### 3. PurchasesBloc Katmani

`PurchasesBloc`, UI ile purchase servisi arasindaki application katmanidir.

Desteklenen event'ler:

- `addSubscriptionFetched`: RevenueCat initialize + offering paketlerini cekme.
- `addPackageSelected`: UI'da secili paketi state'e yazma.
- `addPackagePurchased`: secili paketi satin alma.
- `addPurchasesRestored`: satin alimlari restore etme.

Fetch akisi:

1. State initial hale getirilir.
2. `_purchasesService.initialize(...)` cagrilir.
3. `_purchasesService.getSubsOffering(offeringId: event.offeringId)` ile paketler cekilir.
4. Aktif abonelik varsa `getActiveSubscription()` ile kontrol edilir.
5. Kullanici lifetime degilse, mevcut paketten daha uzun periyotlu paketler upgrade olarak filtrelenir.
6. Paket varsa referans paket en pahali paket olarak, secili paket ise listenin ortasindaki paket olarak atanir.

Satin alma akisi:

1. Secili paket zorunludur.
2. `isPurchasing` true olur.
3. `purchaseSubs(package: selectedPackage)` calisir.
4. Sonuc `failureOrSubscriptionOption` alanina yazilir.
5. UI listener'i basari/hata kararini buradan verir.

Restore akisi:

1. `isRestoring` true olur.
2. RevenueCat tekrar initialize edilir.
3. `restorePurchases()` cagrilir.
4. Sonuc `failureOrRestoredOption` alanina yazilir.

### 4. RevenueCat Servis Katmani

`RevenuecatPurchasesService`, `IPurchasesService` implementasyonudur ve `PurchasesWrapper` uzerinden `purchases_flutter` SDK'sini kullanir.

`initialize`:

- `PurchasesConfiguration(appConfig.revenuecatKey)` olusturur.
- `configuration.appUserID = purchaserId` yapar.
- `Purchases.configure(...)` cagrilir.
- Device identifier'lar toplanir.
- Varsa Adjust ve Facebook anonymous id RevenueCat'e set edilir.

`getSubsOffering`:

- `Purchases.getOfferings()` ile offering'leri alir.
- `offeringId` verilirse sadece o offering'in paketlerini alir.
- Her RevenueCat package'i `SubscriptionPackage` domain modeline cevirir.

`purchaseSubs`:

- Secili domain package id'sine uygun RevenueCat package'i bulur.
- `Purchases.purchasePackage(...)` cagirir.
- Donen `CustomerInfo` icindeki aktif entitlement'i okur.
- Entitlement aktifse `Subscription(plan, period, method: paid)` dondurur.
- Kullanici satin almayi iptal ederse `CancelledFailure`, diger hatalarda `UnknownFailure` dondurur.

`restorePurchases`:

- `Purchases.restorePurchases()` cagirir.
- Donen `CustomerInfo` icinden aktif entitlement bulursa `Subscription` dondurur.
- Aktif entitlement yoksa `NotFoundFailure` dondurur.

## Domain Modelleri

### SubscriptionPlan

Sistemde su an tek plan var:

- `premium`

`SubscriptionPlan.fromProductId(productId)` product id icinde `premium` gecmesini bekler. Bu nedenle RevenueCat / store product id formatlari `premium` kelimesini icermelidir.

### SubscriptionPeriod

Desteklenen periyotlar:

- `week1`
- `month1`
- `month3`
- `month6`
- `month12`
- `lifetime`

`fromProductId` once `weekly`, `monthly`, `yearly`, `lifetime` kelimelerini arar; bulamazsa `1w`, `1m`, `3m`, `6m`, `1y`, `lt` key'lerinden biri product id icinde var mi diye bakar.

### Subscription

Backend/app tarafinda premium bilgi modeli:

- `plan`
- `period`
- `method`
- `renewsAt`
- `expiresAt`

`User.isSubscribed(networkTime:)`, subscription varsa ve `expiresAt` null ya da gelecekteyse true doner.

## Kullanici Modeli ve Premium Karari

`TarotUser.fromMap`, backend'den gelen `premium_info` alanini `Subscription.fromMap(...)` ile parse eder. `premium_info` null ise kullanici premium degildir.

`purchaser.id` su sekilde belirlenir:

1. Backend `revenuecat_id` verirse o kullanilir.
2. Yoksa `user_id` RevenueCat appUserID olarak kullanilir.

Offering mapping app tarafinda sabit:

```dart
SubscriptionPlan.premium: 'premium'
```

Premium kontrolu app icinde dogrudan `user.isSubscribed(...)` yerine `PremiumOverrideService.isPremium(...)` ile yapiliyor. Bu servis iki kaynagi birlestirir:

- Ayarlardaki test override aciksa premium kabul eder.
- Degilse `User.isSubscribed(networkTime:)` sonucunu kullanir.

## Backend Bagimliligi

Satin alma basarili oldugunda `PurchasesBloc` RevenueCat'ten `Subscription` dondurur, ancak uygulamanin kalici premium durumu `AuthCubit.refetchUser()` sonrasi backend'den gelen `premium_info` alanina baglidir.

Bu yuzden tam sistemin dogru calismasi icin backend tarafinda su zincir tamamlanmis olmali:

1. RevenueCat purchase / entitlement aktif olur.
2. RevenueCat webhook veya backend kontrol mekanizmasi ilgili kullanicinin premium bilgisini gunceller.
3. `GET_USER` endpoint'i `premium_info` alanini dondurur.
4. App `AuthCubit.refetchUser()` ile kullaniciyi tekrar ceker.
5. `PremiumOverrideService.isPremium(...)` true donmeye baslar.

Bu backend parcasi app kodunda gorunmuyor; app sadece sonucu `GET_USER` uzerinden okuyor.

## App Icinde Premium Kullanilan Noktalar

### Gunluk acilim limiti

`Step6PageMixin.onStartReading` kullanicinin premium durumuna gore gunluk hak limitini belirler.

- Free limit: `1`
- Premium limit: `2`

Limit dolduysa:

- Premium kullaniciya limit sheet'i gosterilir.
- Free kullanici paywall'a yonlendirilir.

### Okuma kaydetme

`AnswerPageMixin.onSave` ve cevap sayfasindaki save butonu premium kontrolu yapar.

- Premium degilse paywall acilir.
- Premium ise okuma kaydetme request'i `TarotBloc` ile baslatilir.

### Explore header / app bar

Explore header premium degilse "Get Pro" chip'i gosterir. `TarotsProAppBar` da premium degilse pro butonunu gosterme mantigi icerir.

### Settings

Settings icinde:

- Restore purchases tile'i var.
- Test premium switch'i var.
- Test premium acildiginda gunluk kullanim sayaci resetleniyor.

## Hata ve Edge Case Notlari

- `PurchasesBloc._onFetched` icinde debug `print("BLOC PACKAGES: $packages")` var. Production icin kaldirilmasi dusunulebilir.
- Satin alma basarisindan sonra sadece `AuthCubit.refetchUser()` cagriliyor. Backend webhook gec isliyorsa kullanici hemen premium gorunmeyebilir. Boilerplate'te `refetchUserUntilSubscribed(...)` metodu var ama paywall listener'inda kullanilmiyor.
- `RevenuecatPurchasesService.purchaseInfoByCustomerInfo` `expiresAt: null` olusturuyor. App tarafinda `expiresAt == null` aboneligi suresiz aktif sayiyor. Kalici dogruluk backend `premium_info` tarafindan saglanmali.
- Product id'ler `SubscriptionPlan.fromProductId` ve `SubscriptionPeriod.fromProductId` beklentilerine uymali. Aksi halde package mapping hata verir.
- `getActiveSubscription` aktif entitlement'i ilk entitlement uzerinden okuyor. Birden fazla entitlement senaryosu ileride desteklenecekse secim mantigi genisletilmeli.
- Restore sonucunda RevenueCat aktif entitlement bulamazsa `NotFoundFailure` doner; UI bunu genel failure handler ile gosterir.

## Onerilen Iyilestirmeler

1. Satin alma basarili olduktan sonra `refetchUser()` yerine kisa sureli polling icin `refetchUserUntilSubscribed(context.networkNow())` kullanmak daha saglam olur.
2. `print("BLOC PACKAGES: ...")` kaldirilmali veya logger seviyesine alinmali.
3. RevenueCat product id naming kurali dokumante edilmeli: product id hem `premium` hem de period belirleyicisi icermeli.
4. Backend tarafindaki RevenueCat webhook / `premium_info` guncelleme akisi ayrica dokumante edilmeli.
5. `expiresAt: null` davranisi netlestirilmeli; app null'u aktif/suresiz sayiyor.
