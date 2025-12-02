part of '../../pages/tarot_library_page.dart';

class TarotCardGridView extends StatelessWidget {
  const TarotCardGridView({required this.filteredCards, super.key});
  final ValueNotifier<List<TarotLibrary>> filteredCards;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ValueListenableBuilder(
      valueListenable: filteredCards,
      builder: (context, value, child) {
        final filteredCardsList = filteredCards.value;

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
              itemCount: filteredCardsList.length,
              itemBuilder: (context, index) {
                final card = filteredCardsList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ScalingContainer(
                        onTap: () async {
                          await context.push(
                            AppRoutes.tarotLibraryDetail,
                            extra: {
                              'tarot': card.toMap(),
                              'imagePath': card.imagePath,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: Spacing.xsmallBorderRadius,
                            border: Border.all(
                              color: colors.primary,
                              width: 4,
                            ),
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
              },
            ),
          ),
        );
      },
    );
  }
}

class _ImageLoadingShimmer extends StatelessWidget {
  const _ImageLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Shimmer(
      duration: const Duration(milliseconds: 1500),
      color: colors.primary.withValues(alpha: 0.3),
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
