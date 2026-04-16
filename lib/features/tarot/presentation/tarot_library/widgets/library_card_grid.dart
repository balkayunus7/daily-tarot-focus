part of '../pages/tarot_library_page.dart';

class LibraryCardGridView extends StatelessWidget {
  const LibraryCardGridView({required this.filteredCards, super.key});
  final List<TarotCardModel> filteredCards;

  @override
  Widget build(BuildContext context) {
    final scope = LibraryPageScope.of(context);

    return Expanded(
      child: Padding(
        padding: Sp.large.padHR,
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
            final isPremium = index >= scope.state.freeCardCount;
            return _LibraryCard(card: card, isPremium: isPremium);
          },
        ),
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({required this.card, required this.isPremium});
  final TarotCardModel card;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current.isAuthenticated,
      builder: (context, state) {
        final networkTime = context.networkNow();
        final isSubscribed = state.userOrCrash.isSubscribed(networkTime: networkTime);
        final showLock = isPremium && !isSubscribed;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ScalingContainer(
                onTap: () async {
                  if (showLock) {
                    await context.push(AppRoutes.subscriptionPaywall);
                  } else {
                    await context.pushNamed(
                      AppRoutes.tarotLibraryDetail,
                      pathParameters: {'tarotId': card.name},
                    );
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: Sp.xsmall.radiusR,
                        border: Border.all(color: colors.border, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: Sp.tiny.radiusR,
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

                    if (showLock) ...[
                      ClipRRect(
                        borderRadius: Sp.tiny.radiusR,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.colors.overlay,
                            borderRadius: Sp.tiny.radiusR,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: Sp.tiny.padAllR,
                          decoration: BoxDecoration(
                            color: context.colors.secondary,
                            borderRadius: Sp.xsmall.radiusR,
                            boxShadow: context.colors.primary.mediumShadow,
                          ),
                          child: SvgPicture.asset(
                            TarotAppAssets.crown.path,
                            width: 12,
                            height: 12,
                            colorFilter: ColorFilter.mode(
                              colors.textOnPrimary.withValues(alpha: 0.5),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
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
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.primary, colors.gradientEnd, colors.background],
      ),
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(borderRadius: Sp.tiny.radiusR),
        ),
      ),
    );
  }
}
