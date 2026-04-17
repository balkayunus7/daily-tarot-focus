part of '../pages/tarot_deck_page.dart';

class DeckRetryWidget extends StatelessWidget {
  const DeckRetryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TarotLocalizationCubit, TarotLocalizationState>(
      builder: (context, lclState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GlassButton(
              onTap: () async {
                final cubit = context.read<TarotLocalizationCubit>();
                await cubit.loadCards(context.locale.languageCode);
              },
              buttonText: 'Load Cards',
              paddingHorizontal: 20,
              width: 144,
              height: 48,
              buttonTextStyle: m10w600(context),
              borderRadius: Sp.xlarge.radiusR,
            ),
            Sp.xxlarge.heightBox,
            Image.asset(
              TarotAppAssets.empty.path,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.contain,
            ),
          ],
        );
      },
    );
  }
}
