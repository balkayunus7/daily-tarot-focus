import 'package:daily_tarot_focus/config/env.config.dart';
import 'package:mobile_boilerplate/app_config.dart';

final envConfig = EnvConfig();

class TarotAppConfig extends AppConfig {
  TarotAppConfig()
    : super(
        appVersion: 1,
        meta: '123',
        apiHost: 'https://yilmaz-2.aiplaylist.co',
        wsHost: 'random',
        appName: 'Daily Tarot Focus',
        adjustSDK: envConfig.adjustSdkKey,
        androidRevenuecatKey: envConfig.revenuecatApiKey,
        mailToUrl: 'https://sites.google.com/view/tarotdailyfocussuppor/',
        termsOfServiceUrl: 'https://sites.google.com/view/tarotdailyfocustermsconditions',
        iosRevenuecatKey: envConfig.revenuecatApiKey,
        privacyPolicyUrl: 'https://sites.google.com/view/tarot-daily-privacy-policy',
        appStoreUrl: 'https://apps.apple.com/app/id6757164771?action=write-review',
        playStoreUrl: '',
      );
}
