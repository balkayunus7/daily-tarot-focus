part of '../../pages/tarot_page.dart';

class TarotPaywallCard extends StatelessWidget {
  const TarotPaywallCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.secondary,
            colors.accent,
          ],
        ),
        borderRadius: Spacing.defaultBorderRadius,
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.white,
            size: 28,
          ),
          Spacing.smallW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Go Premium',
                  style: m18w700(context).copyWith(color: Colors.white),
                ),
                Spacing.tinyH,
                Text(
                  'Unlock all features',
                  style: m12w500(context).copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          TarotButton(
            height: 40,
            width: 100,
            onTap: () {},
            buttonText: 'Get Pro',
            bgColor: colors.textPrimary,
            buttonTextStyle: m14w700(
              context,
            ).copyWith(color: colors.primary),
          ),
        ],
      ),
    );
  }
}
