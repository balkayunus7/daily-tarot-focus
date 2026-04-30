part of '../pages/tarot_deck_page.dart';

class DeckCardGridView extends StatelessWidget {
  const DeckCardGridView({required this.filteredCards, super.key});
  final List<TarotCardModel> filteredCards;

  @override
  Widget build(BuildContext context) {
    final scope = DeckPageScope.of(context);

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
            return _DeckCard(card: card, isPremium: isPremium);
          },
        ),
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({required this.card, required this.isPremium});
  final TarotCardModel card;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current.isAuthenticated,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ScalingContainer(
                onTap: () async {
                  await context.pushNamed(
                    AppRoutes.tarotDeckDetail,
                    pathParameters: {'tarotId': card.id},
                  );
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
                        child: CustomCacheNetworkImage(imageUrl: card.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
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
