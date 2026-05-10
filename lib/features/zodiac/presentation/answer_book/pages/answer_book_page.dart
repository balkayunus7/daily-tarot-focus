import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class AnswerBookPage extends StatefulWidget {
  const AnswerBookPage({super.key});

  @override
  State<AnswerBookPage> createState() => _AnswerBookPageState();
}

class _AnswerBookPageState extends State<AnswerBookPage> with TickerProviderStateMixin {
  static const _answersEn = [
    'It is certain.',
    'Go for it.',
    'Absolutely yes.',
    'Without a doubt.',
    'The time is now.',
    'You already know the answer.',
    'Trust your instincts.',
    'Take the leap.',
    'Yes.',
    'All signs point to yes.',
    'It is your destiny.',
    'Move forward with confidence.',
    'The stars are aligned for this.',
    'Expect a miracle.',
    'Do not hesitate.',
    'Your path is clear.',
    'Embrace the opportunity.',
    'It will bring you joy.',
    'A resounding yes.',
    'The universe supports you.',
    'It is highly likely.',
    'Success is near.',
    'Follow your heart.',
    'You are ready.',
    'The outcome will be positive.',
    'Listen to your inner voice.',
    'Do it.',
    'This is the right choice.',
    'Everything is in your favor.',
    'You have nothing to lose.',
    'It will be worth it.',
    'Proceed with passion.',
    'Yes, but take it step by step.',
    'Fortune favors the bold.',
    'It is a stepping stone.',
    'You are on the right path.',
    'The answer is a clear yes.',
    'Believe in it.',
    'Let your excitement guide you.',
    'It is a meant-to-be moment.',
    'No.',
    'Definitely not.',
    'Do not bet on it.',
    'Reconsider your approach.',
    'It is not the right time.',
    'Walk away.',
    'Absolutely not.',
    'The odds are against it.',
    'It is a distraction.',
    'Do not risk it.',
    'The answer is no.',
    'Look for another way.',
    'You are focusing on the wrong thing.',
    'It will only bring trouble.',
    'Stop and think.',
    'Not now.',
    'It is an illusion.',
    'Do not force it.',
    'There are better options.',
    'Let it go.',
    'It is not meant for you.',
    'Save your energy.',
    'Turn back.',
    'A firm no.',
    'This path is blocked.',
    'You will regret it.',
    'It is a dead end.',
    'Do not be fooled.',
    'Leave it behind.',
    'You deserve better.',
    'It is not worth the effort.',
    'Say no.',
    'Wait.',
    'Be patient.',
    'Not yet.',
    'Give it some time.',
    'The timing is wrong.',
    'Bide your time.',
    'Pause and reflect.',
    'Patience will reward you.',
    'Ask again later.',
    'Sleep on it.',
    'Do not rush.',
    'Wait for a sign.',
    'Let the dust settle.',
    'Timing is everything, wait.',
    'Hold your ground.',
    'Watch and wait.',
    'The situation will change soon.',
    'Patience is required.',
    'Let things unfold naturally.',
    'Do not make a move yet.',
    'Take a step back.',
    'Wait for the right moment.',
    'There is no need to hurry.',
    'Delay your decision.',
    'Time will tell.',
    'Breathe and wait.',
    'It is too early to tell.',
    'Observe closely first.',
    'Let tomorrow decide.',
    'Give it another week.',
    'Wait for more information.',
    'Seek advice.',
    'Ask a trusted friend.',
    'Look closer.',
    'Change your perspective.',
    'Focus on yourself.',
    'Listen more, speak less.',
    'Create your own luck.',
    'Keep an open mind.',
    'Take a risk.',
    'Pay attention to details.',
    'Follow the open doors.',
    'Explore other possibilities.',
    'Look at the bigger picture.',
    'Trust the process.',
    'Make a plan first.',
    'Focus on what matters.',
    'Start small.',
    'Do the unexpected.',
    'Break the rules.',
    'Stay grounded.',
    'Keep your balance.',
    'Find your center.',
    'Forgive and move on.',
    'Accept the truth.',
    'Let go of control.',
    'Find the hidden meaning.',
    'Act with kindness.',
    'Challenge yourself.',
    'Think outside the box.',
    'Stay out of it.',
    'Keep it a secret.',
    'Express yourself clearly.',
    'Take responsibility.',
    'Show gratitude.',
    'Let your intuition lead.',
    'Quiet your mind.',
    'The answer is in your dreams.',
    'Meditate on it.',
    'Read between the lines.',
    'Look for synchronicities.',
    'A surprise is coming.',
    'Trust the unknown.',
    'Embrace the mystery.',
    'Your spirit guides are watching.',
    'Magic is at work.',
    'A door is opening.',
    'Follow the light.',
    'The energy is shifting.',
    'Listen to the silence.',
    'Seek the truth within.',
    'Let the universe decide.',
    'You are protected.',
    'An old friend holds the key.',
    'Look to the past for the answer.',
    'The future is unwritten.',
    'A new cycle is beginning.',
    'Release your fears.',
    'You hold the power.',
    'Trust the journey.',
    'It is a karmic lesson.',
    'Your aura is strong.',
    'A sudden realization will come.',
    'The shadows hide the truth.',
    'Look for the silver lining.',
    'Follow the signs.',
    'Nature has the answer.',
    'Keep your energy pure.',
    'You are a magnet for miracles.',
    'Let the water clear.',
    'The wind is changing direction.',
    'A spark will ignite.',
    'Balance your energies.',
    'The connection is deep.',
    'It is hidden from view.',
    'Search your soul.',
    'Trust the flow of life.',
    'You are exactly where you need to be.',
    'The pieces will fall into place.',
    'A revelation is imminent.',
    'Guard your heart.',
    'Open your mind.',
    'The answer is a feeling.',
    'Follow your passion.',
    'It is written in the stars.',
    'Trust your inner wisdom.',
    'You are not alone.',
    'The answer is closer than you think.',
    'Embrace the change.',
    'Focus on the present moment.',
    'You have the strength.',
    'Let love guide you.',
    'It is a test of faith.',
    'The truth will reveal itself.',
    'Your destiny is calling.',
  ];

  static const _answersTr = [
    'Kesin.',
    'Harekete geç.',
    'Kesinlikle evet.',
    'Şüphesiz.',
    'Tam zamanı.',
    'Cevabı zaten biliyorsun.',
    'İçgüdülerine güven.',
    'Adımını at.',
    'Evet.',
    'Tüm işaretler eveti gösteriyor.',
    'Bu senin kaderin.',
    'Özgüvenle ilerle.',
    'Yıldızlar bunun için hizalanıyor.',
    'Bir mucize bekle.',
    'Tereddüt etme.',
    'Yolun açık.',
    'Fırsatı kucakla.',
    'Sana neşe getirecek.',
    'Güçlü bir evet.',
    'Evren seni destekliyor.',
    'Büyük ihtimalle.',
    'Başarı çok yakın.',
    'Kalbinin sesini dinle.',
    'Hazırsın.',
    'Sonuç olumlu olacak.',
    'İç sesini dinle.',
    'Yap.',
    'Bu doğru bir seçim.',
    'Her şey senin lehine.',
    'Kaybedecek hiçbir şeyin yok.',
    'Buna değecek.',
    'Tutkuyla ilerle.',
    'Evet, ama adım adım ilerle.',
    'Şans cesurlardan yanadır.',
    'Bu bir basamak.',
    'Doğru yoldasın.',
    'Cevap net bir evet.',
    'Buna inan.',
    'Heyecanının sana rehberlik etmesine izin ver.',
    'Olması gereken bir an.',
    'Hayır.',
    'Kesinlikle hayır.',
    'Buna bel bağlama.',
    'Yaklaşımını gözden geçir.',
    'Doğru zaman değil.',
    'Uzaklaş.',
    'Asla.',
    'İhtimaller buna karşı.',
    'Bu bir dikkat dağınıklığı.',
    'Bunu riske atma.',
    'Cevap hayır.',
    'Başka bir yol ara.',
    'Yanlış şeye odaklanıyorsun.',
    'Sadece sorun getirecek.',
    'Dur ve düşün.',
    'Şimdi değil.',
    'Bu bir yanılsama.',
    'Zorlama.',
    'Daha iyi seçenekler var.',
    'Bırak gitsin.',
    'Senin için uygun değil.',
    'Enerjini sakla.',
    'Geri dön.',
    'Kesin bir hayır.',
    'Bu yol kapalı.',
    'Pişman olacaksın.',
    'Bu bir çıkmaz sokak.',
    'Kanma.',
    'Bunu geride bırak.',
    'Daha iyisini hak ediyorsun.',
    'Çabaya değmez.',
    'Hayır de.',
    'Bekle.',
    'Sabırlı ol.',
    'Henüz değil.',
    'Biraz zaman ver.',
    'Zamanlama yanlış.',
    'Zamanını bekle.',
    'Durakla ve düşün.',
    'Sabır seni ödüllendirecek.',
    'Daha sonra tekrar sor.',
    'Üzerine bir gece uyu.',
    'Acele etme.',
    'Bir işaret bekle.',
    'Suların durulmasını bekle.',
    'Zamanlama her şeydir, bekle.',
    'Durumunu koru.',
    'İzle ve bekle.',
    'Durum yakında değişecek.',
    'Sabır gerekiyor.',
    'Bırak her şey doğal gelişsin.',
    'Henüz bir hamle yapma.',
    'Bir adım geri çekil.',
    'Doğru anı bekle.',
    'Acele etmene gerek yok.',
    'Kararını ertele.',
    'Zaman gösterecek.',
    'Nefes al ve bekle.',
    'Söylemek için çok erken.',
    'Önce yakından gözlemle.',
    'Bırak yarın karar versin.',
    'Bir hafta daha ver.',
    'Daha fazla bilgi bekle.',
    'Tavsiye al.',
    'Güvendiğin birine sor.',
    'Daha yakından bak.',
    'Bakış açını değiştir.',
    'Kendine odaklan.',
    'Daha çok dinle, daha az konuş.',
    'Kendi şansını yarat.',
    'Açık fikirli ol.',
    'Risk al.',
    'Detaylara dikkat et.',
    'Açık kapıları takip et.',
    'Diğer olasılıkları keşfet.',
    'Büyük resme bak.',
    'Sürece güven.',
    'Önce bir plan yap.',
    'Önemli olana odaklan.',
    'Küçük başla.',
    'Beklenmeyeni yap.',
    'Kuralları yık.',
    'Ayakların yere bassın.',
    'Dengeni koru.',
    'Merkezini bul.',
    'Affet ve yoluna devam et.',
    'Gerçeği kabul et.',
    'Kontrolü bırak.',
    'Gizli anlamı bul.',
    'Nezaketle hareket et.',
    'Kendine meydan oku.',
    'Farklı düşün.',
    'Dışında kal.',
    'Bunu sır olarak sakla.',
    'Kendini net ifade et.',
    'Sorumluluk al.',
    'Minnettarlık göster.',
    'Sezgilerinin yol göstermesine izin ver.',
    'Zihnini sustur.',
    'Cevap rüyalarında.',
    'Üzerine meditasyon yap.',
    'Satır aralarını oku.',
    'Eşzamanlılıkları ara.',
    'Bir sürpriz yaklaşıyor.',
    'Bilinmeyene güven.',
    'Gizemi kucakla.',
    'Ruhsal rehberlerin seni izliyor.',
    'Sihir iş başında.',
    'Bir kapı açılıyor.',
    'Işığı takip et.',
    'Enerji değişiyor.',
    'Sessizliği dinle.',
    'İçindeki gerçeği ara.',
    'Bırak evren karar versin.',
    'Korunuyorsun.',
    'Anahtar eski bir dostta.',
    'Cevap için geçmişe bak.',
    'Gelecek henüz yazılmadı.',
    'Yeni bir döngü başlıyor.',
    'Korkularını serbest bırak.',
    'Güç senin elinde.',
    'Yolculuğa güven.',
    'Bu karmik bir ders.',
    'Auran güçlü.',
    'Aniden bir aydınlanma yaşayacaksın.',
    'Gölgeler gerçeği saklıyor.',
    'İşin iyi tarafını gör.',
    'İşaretleri takip et.',
    'Doğanın cevabı var.',
    'Enerjini saf tut.',
    'Mucizeler için bir mıknatıssın.',
    'Bırak sular berraklaşsın.',
    'Rüzgar yön değiştiriyor.',
    'Bir kıvılcım alev alacak.',
    'Enerjilerini dengele.',
    'Bağlantı çok derin.',
    'Bu gözden gizlenmiş.',
    'Ruhunun derinliklerini ara.',
    'Hayatın akışına güven.',
    'Tam olman gereken yerdesin.',
    'Parçalar yerine oturacak.',
    'Bir aydınlanma çok yakın.',
    'Kalbini koru.',
    'Zihnini aç.',
    'Cevap aslında bir his.',
    'Tutkunu takip et.',
    'Bu yıldızlarda yazılı.',
    'İçsel bilgeliğine güven.',
    'Yalnız değilsin.',
    'Cevap sandığından daha yakın.',
    'Değişimi kucakla.',
    'Şu ana odaklan.',
    'Güce sahipsin.',
    'Sevginin sana rehberlik etmesine izin ver.',
    'Bu bir inanç testi.',
    'Gerçek kendini gösterecek.',
    'Kaderin seni çağırıyor.',
  ];

  late final AnimationController _flipController;
  late final AnimationController _revealController;
  Timer? _cycleTimer;
  bool _isAnswerShown = false;
  late int _currentIndex;

  List<String> get _answers {
    final locale = context.locale.languageCode;
    return locale == 'tr' ? _answersTr : _answersEn;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = Random().nextInt(_answersEn.length);

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _startCycling();
  }

  void _startCycling() {
    _cycleTimer?.cancel();
    setState(() => _isAnswerShown = false);
    _revealController.reverse().then((_) {
      if (!mounted) return;
      setState(() => _currentIndex = Random().nextInt(_answers.length));
      _cycleTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
        if (mounted) {
          setState(() => _currentIndex = Random().nextInt(_answers.length));
        }
      });
    });
  }

  void _revealAnswer() {
    if (_isAnswerShown) return;
    _cycleTimer?.cancel();
    setState(() => _isAnswerShown = true);
    _revealController.forward();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _revealController.dispose();
    _cycleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TarotAppBar(
              title: LocaleKeys.answer_book_page_title.tr(),
              titleStyle: m18w700(context),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _revealAnswer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    _BookVisual(
                      flipController: _flipController,
                      revealController: _revealController,
                      answer: _answers[_currentIndex],
                    ),
                    const Spacer(),
                    _BottomSection(
                      isAnswerShown: _isAnswerShown,
                      onAskAgain: _startCycling,
                      revealController: _revealController,
                    ),
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookVisual extends StatelessWidget {
  const _BookVisual({
    required this.flipController,
    required this.revealController,
    required this.answer,
  });

  final AnimationController flipController;
  final AnimationController revealController;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final size = 260.r;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Book is always animating — even when answer is shown on top
          AnimatedBuilder(
            animation: flipController,
            builder: (context, _) {
              final blur = 0.5 + sin(flipController.value * pi * 2).abs() * 0.5;
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: _BookIllustration(flipValue: flipController.value, size: size),
              );
            },
          ),
          // Answer text — top layer over the still-spinning book
          FadeTransition(
            opacity: revealController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                answer,
                style: m18w700(context).copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                  height: 1.35,
                  shadows: [
                    Shadow(color: Colors.black.withValues(alpha: 0.85), blurRadius: 16),
                    Shadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 4),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookIllustration extends StatelessWidget {
  const _BookIllustration({required this.flipValue, required this.size});

  final double flipValue;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CustomPaint(
      size: Size(size, size),
      painter: _BookPainter(
        primaryColor: colors.primary,
        secondaryColor: colors.secondary,
        accentColor: colors.accent,
        flipValue: flipValue,
      ),
    );
  }
}

class _BookPainter extends CustomPainter {
  const _BookPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.flipValue,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final double flipValue;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final bookW = size.width * 0.82;
    final bookH = size.height * 0.72;
    final bookLeft = cx - bookW / 2;
    final bookTop = cy - bookH / 2 + size.height * 0.04;

    const radius = Radius.circular(6);

    // Shadow
    final shadowPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bookLeft + 8, bookTop + 12, bookW, bookH),
        radius,
      ),
      shadowPaint,
    );

    // Left page (cover)
    final leftRect = Rect.fromLTWH(bookLeft, bookTop, bookW / 2, bookH);
    final leftGrad =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(primaryColor, Colors.black, 0.3)!,
              Color.lerp(secondaryColor, Colors.black, 0.1)!,
            ],
          ).createShader(leftRect);

    canvas.drawRRect(
      RRect.fromRectAndCorners(leftRect, topLeft: radius, bottomLeft: radius),
      leftGrad,
    );

    // Right page (pages)
    final rightRect = Rect.fromLTWH(bookLeft + bookW / 2, bookTop, bookW / 2, bookH);
    final pageColor = Color.lerp(Colors.white, const Color(0xFFF5EFE6), 0.7)!;
    final rightGrad =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [pageColor.withValues(alpha: 0.85), pageColor],
          ).createShader(rightRect);

    canvas.drawRRect(
      RRect.fromRectAndCorners(rightRect, topRight: radius, bottomRight: radius),
      rightGrad,
    );

    // Spine
    final spinePaint =
        Paint()
          ..color = Color.lerp(primaryColor, Colors.black, 0.5)!
          ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(cx - 4, bookTop, 8, bookH),
      spinePaint,
    );

    // Left cover ornament (star/sparkle shape)
    _drawCoverOrnament(canvas, Offset(bookLeft + bookW / 4, bookTop + bookH / 2), bookH * 0.18);

    // Flipping pages — book is always animating
    _drawFlippingPages(canvas, bookLeft, bookTop, bookW, bookH, radius);
  }

  void _drawCoverOrnament(Canvas canvas, Offset center, double r) {
    final paint =
        Paint()
          ..color = accentColor.withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;

    // Simple 6-pointed star
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final outer = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
      final inner = Offset(
        center.dx + r * 0.4 * cos(angle + pi / 6),
        center.dy + r * 0.4 * sin(angle + pi / 6),
      );
      canvas.drawLine(center, outer, paint);
      canvas.drawLine(outer, inner, paint..strokeWidth = 0.8);
    }

    canvas.drawCircle(
      center,
      r * 0.18,
      Paint()
        ..color = accentColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawFlippingPages(
    Canvas canvas,
    double bookLeft,
    double bookTop,
    double bookW,
    double bookH,
    Radius radius,
  ) {
    final cx = bookLeft + bookW / 2;
    final pageW = bookW / 2;
    const unreadColor = Color(0xFFF0E8D8);

    // Sağ taraf: henüz çevrilmemiş sayfa yığını (kalınlık hissi)
    for (var i = 3; i >= 1; i--) {
      final dx = i * 0.8;
      final dy = i * 0.4;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(cx + dx, bookTop + dy, pageW - dx, bookH - dy * 2),
          topRight: radius,
          bottomRight: radius,
        ),
        Paint()..color = unreadColor.withValues(alpha: 0.35 - i * 0.05),
      );
    }

    // 3 sayfa farklı fazlarda Y ekseni etrafında dönüyor
    // Geriden öne sırala: phase >= 0.5 olanlar (sol tarafta) önce, sonra sağdakiler
    final phases = <double>[
      flipValue,
      (flipValue + 0.33) % 1.0,
      (flipValue + 0.66) % 1.0,
    ];

    final pivotY = bookTop + bookH / 2;

    // Önce sol tarafta olanları (phase >= 0.5) çiz, sonra sağda olanları üstüne
    final leftPhases = phases.where((p) => p >= 0.5).toList()..sort((a, b) => b.compareTo(a));
    final rightPhases = phases.where((p) => p < 0.5).toList()..sort();

    for (final p in leftPhases) {
      _drawSingleFlipPage(canvas, cx, pivotY, bookTop, pageW, bookH, p, radius);
    }
    for (final p in rightPhases) {
      _drawSingleFlipPage(canvas, cx, pivotY, bookTop, pageW, bookH, p, radius);
    }
  }

  void _drawSingleFlipPage(
    Canvas canvas,
    double cx,
    double pivotY,
    double bookTop,
    double pageW,
    double bookH,
    double phase,
    Radius radius,
  ) {
    final angle = phase * pi; // 0 → π (gerçek 180° dönüş)
    final isFront = phase < 0.5;

    canvas.save();

    // Spine (cx, pivotY) etrafında Y ekseninde 3D perspektifli dönüş
    // pivotY kitabın dikey merkezinde — perspektif distorsiyonu üst+alt simetrik
    final matrix =
        Matrix4.identity()
          ..setEntry(3, 2, 0.0018)
          ..translate(cx, pivotY)
          ..rotateY(angle)
          ..translate(-cx, -pivotY);
    canvas.transform(matrix.storage);

    // Sayfa rengi: ön yüz açık, arka yüz biraz daha koyu
    final basePage = isFront ? const Color(0xFFF5EFE6) : const Color(0xFFE4D6BC);
    // Açıyla hafif gölgelenme — düz konumda parlak, açılı konumda hafif koyu
    final brightness = 0.82 + cos(angle).abs() * 0.18;
    final pageColor = Color.lerp(const Color(0xFF6B5840), basePage, brightness)!;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx, bookTop, pageW, bookH),
        topRight: radius,
        bottomRight: radius,
      ),
      Paint()..color = pageColor,
    );

    // Ön yüzdeyken yazı çizgileri — düz olduğunda görünür, açılınca silikleşir
    if (isFront) {
      final visibility = cos(angle).clamp(0.0, 1.0);
      if (visibility > 0.25) {
        final linePaint =
            Paint()
              ..color = Colors.grey.withValues(alpha: 0.22 * visibility)
              ..strokeWidth = 0.6;
        for (var j = 1; j <= 4; j++) {
          final y = bookTop + bookH * (j / 5.5);
          final marginH = pageW * 0.08;
          canvas.drawLine(
            Offset(cx + marginH, y),
            Offset(cx + pageW - marginH, y),
            linePaint,
          );
        }
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_BookPainter old) =>
      old.flipValue != flipValue || old.primaryColor != primaryColor;
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.isAnswerShown,
    required this.onAskAgain,
    required this.revealController,
  });

  final bool isAnswerShown;
  final VoidCallback onAskAgain;
  final AnimationController revealController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ensure the section size is always maintained to prevent layout jumps
        IgnorePointer(
          ignoring: isAnswerShown,
          child: AnimatedOpacity(
            opacity: isAnswerShown ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.answer_book_subtitle.tr(),
                    style: m18w700(context),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.vibration_rounded,
                          label: LocaleKeys.answer_book_shake_label.tr(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          LocaleKeys.answer_book_or.tr(),
                          style: m13w500(context).copyWith(color: colors.textSecondary),
                        ),
                      ),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.touch_app_rounded,
                          label: LocaleKeys.answer_book_tap_instruction.tr(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !isAnswerShown,
          child: FadeTransition(
            opacity: revealController,
            child: ScalingContainer(
              onTap: onAskAgain,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colors.gradientStart, colors.gradientEnd]),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  LocaleKeys.answer_book_ask_again.tr(),
                  style: m15w600(context).copyWith(color: colors.textOnPrimary),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.borderSecondary, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.primary, size: 26.r),
          SizedBox(height: 8.h),
          Text(
            label,
            style: m13w500(context).copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
