part of '../pages/tarot_reveal_page.dart';

class _RevealCooldownView extends StatelessWidget {
  const _RevealCooldownView({required this.formatted});

  final String formatted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glow + moon icon
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
              formatted,
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
  }
}
