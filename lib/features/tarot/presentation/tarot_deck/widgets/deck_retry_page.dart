part of '../pages/tarot_deck_page.dart';

class DeckRetryWidget extends StatelessWidget {
  const DeckRetryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FancyButton(
              onTap: () async {
                final authState = context.read<AuthCubit>().state;
                context.read<TarotBloc>().addFetchAllCardsRequested(
                  request: FetchAllCardsRequest(session: authState.sessionOrCrash),
                );
              },
              text: 'Load Cards',
              height: 40,
              textStyle: m10w600(context).copyWith(color: context.colors.textOnPrimary),
            ),
            Sp.xxlarge.heightBox,
            CustomCacheNetworkImage(
              imageUrl: TarotAppAssets.emptyHttp,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ],
        );
      },
    );
  }
}
