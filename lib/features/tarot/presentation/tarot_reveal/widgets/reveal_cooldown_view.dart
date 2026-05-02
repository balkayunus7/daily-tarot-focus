import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RevealCooldownView extends StatelessWidget {
  const RevealCooldownView({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    final colors = context.colors;

    return ValueListenableBuilder<Duration>(
      valueListenable: scope.remaining,
      builder: (context, dur, _) {
        return SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.secondary.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.25),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.nightlight_round, color: Color(0xFFE8D5A3), size: 48),
                  ),
                ),
                Sp.xlarge.heightBox,
                Text(
                  scope.formatDuration(dur),
                  style: m28w600(context).copyWith(
                    color: colors.textPrimary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                    letterSpacing: 2,
                  ),
                ),
                Sp.small.heightBox,
                Text(
                  LocaleKeys.reveal_page_cooldown_subtitle.tr(),
                  style: m13w500(context).copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
