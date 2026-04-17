part of 'settings_page.dart';

Future<void> _showLanguageBottomSheet(BuildContext context) async {
  final colors = context.colors;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.background,
    shape: RoundedRectangleBorder(
      borderRadius: Sp.xlarge.radiusOnlyR(tl: true, tr: true),
    ),
    builder: (context) {
      return Padding(
        padding: Sp.xlarge.padAllR,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderSecondary,
                  borderRadius: 2.radiusR,
                ),
              ),
            ),
            Sp.large.heightBox,
            Text(
              LocaleKeys.settings_page_choose_language.tr(),
              style: m18w600(context),
            ),
            Sp.large.heightBox,
            _LanguageOption(
              title: LocaleKeys.settings_page_english.tr(),
              locale: context.localeEn,
              isSelected: context.isLocaleEn,
              onTap: () async {
                await context.setLocale(context.localeEn);
                final langCode = LocaleLanguage.en.value;

                if (context.mounted) {
                  await context.read<TarotLocalizationCubit>().refreshCards(langCode);
                  if (context.mounted) {
                    final session = context.read<AuthCubit>().state.sessionOrCrash;
                    context.read<TarotBloc>().addFetchDailyCardsRequested(
                      request: FetchDailyCardsRequest(session: session, languageCode: langCode),
                    );
                  }
                }
                await HapticFeedbackHelper.selectionClick();
                if (context.mounted) Navigator.pop(context);
              },
            ),
            Sp.xsmall.heightBox,
            _LanguageOption(
              title: LocaleKeys.settings_page_turkish.tr(),
              locale: context.localeTr,
              isSelected: context.isLocaleTr,
              onTap: () async {
                await context.setLocale(context.localeTr);
                final langCode = LocaleLanguage.tr.value;

                if (context.mounted) {
                  await context.read<TarotLocalizationCubit>().refreshCards(langCode);
                  if (context.mounted) {
                    final session = context.read<AuthCubit>().state.sessionOrCrash;
                    context.read<TarotBloc>().addFetchDailyCardsRequested(
                      request: FetchDailyCardsRequest(session: session, languageCode: langCode),
                    );
                  }
                }
                await HapticFeedbackHelper.selectionClick();
                if (context.mounted) Navigator.pop(context);
              },
            ),
            Sp.large.heightBox,
          ],
        ),
      );
    },
  );
}
