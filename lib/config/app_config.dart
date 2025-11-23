import 'package:daily_tarot_focus/config/env.config.dart';
import 'package:mobile_boilerplate/app_config.dart';

final envConfig = EnvConfig();

class LyricsAppConfig extends AppConfig {
  LyricsAppConfig()
    : super(
        appVersion: 1,
        meta: '123',
        apiHost: 'https://yilmaz-2.aiplaylist.co',
        wsHost: 'random',
        appName: 'Dynamic Lyrics',
        adjustSDK: envConfig.adjustSdkKey,
        androidRevenuecatKey: envConfig.revenuecatApiKey,
        mailToUrl: 'https://sites.google.com/view/contactinfoside/',
        termsOfServiceUrl:
            'https://sites.google.com/view/mindcheckanxietytracker/ana-sayfa',
        iosRevenuecatKey: envConfig.revenuecatApiKey,
        privacyPolicyUrl:
            'https://sites.google.com/view/mind-check-anxiety-tracker/ana-sayfa',
        appStoreUrl:
            'https://apps.apple.com/app/id6753744844?action=write-review',
        playStoreUrl: '',
      );
}
