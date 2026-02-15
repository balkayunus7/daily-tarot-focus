part of '../pages/tarot_library_page.dart';

class LibraryCardGridView extends StatelessWidget {
  const LibraryCardGridView({required this.filteredCards, super.key});
  final List<TarotData> filteredCards;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: filteredCards.length,
          itemBuilder: (context, index) {
            final card = filteredCards[index];
            return _LibraryCard(card: card);
          },
        ),
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({required this.card});

  final TarotData card;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ScalingContainer(
            onTap: () async {
              await context.pushNamed(
                AppRoutes.tarotLibraryDetail,
                pathParameters: {'tarotId': card.title},
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: Spacing.xsmallBorderRadius,
                border: Border.all(color: colors.primary, width: 4),
              ),
              child: ClipRRect(
                borderRadius: Spacing.tinyBorderRadius,
                child: Image.asset(
                  card.imagePath,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  frameBuilder: (_, child, frame, _) {
                    if (frame != null) return child;
                    return const _ImageLoadingShimmer();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageLoadingShimmer extends StatelessWidget {
  const _ImageLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Shimmer(
      gradient: LinearGradient(
        colors: [
          colors.primary.withValues(alpha: 0.1),
          colors.primary.withValues(alpha: 0.3),
          colors.primary.withValues(alpha: 0.1),
        ],
      ),
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: Spacing.tinyBorderRadius,
            color: colors.primary.withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }
}
