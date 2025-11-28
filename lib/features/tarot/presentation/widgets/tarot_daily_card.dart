part of '../pages/tarot_page.dart';

class TarotDailyCard extends StatelessWidget {
  const TarotDailyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.dailyTarotReveal),
      child: Container(
        width: double.infinity,
        height: 180,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colors.accent,
              context.colors.primary,
            ],
          ),
          borderRadius: Spacing.largeBorderRadius,
          border: Border.all(color: context.colors.borderSecondary, width: 0.5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Günün kartı ile gücünü keşfet!',
                    style: m18w600(context),
                  ),
                  Spacing.mediumH,
                  IgnorePointer(
                    child: UnconstrainedBox(
                      alignment: Alignment.centerLeft,
                      child: TarotButton(
                        height: 40,
                        width: 120,
                        onTap: () {},
                        buttonText: 'Kartı Keşfet!',
                        bgColor: context.colors.accent,
                        buttonTextStyle: m12w600(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const _DailyCardImage(),
          ],
        ),
      ),
    );
  }
}

class _DailyCardImage extends StatelessWidget {
  const _DailyCardImage();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -15,
      top: -10,
      bottom: -10,
      child: Hero(
        tag: 'daily_tarot_card_hero', 
        child: Transform.rotate(
          angle: -0.15,
          child: Container(
            width: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                TarotAppAssets.cardDesign.path, 
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
