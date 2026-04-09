import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/application/launcher/launcher.dart';
import 'package:mobile_boilerplate/application/purchases/purchases_bloc.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/core_app.dart';
import 'package:mobile_boilerplate/presentation/common/loading_page.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_failure_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  BlocListener<PurchasesBloc, PurchasesState> _restoringListener() =>
      BlocListener<PurchasesBloc, PurchasesState>(
        listenWhen: (p, c) => p.isRestoring != c.isRestoring,
        listener: (context, state) async {
          if (state.isRestoring) {
            await LoadingPage.push(context);
          } else {
            Navigator.of(context).pop();
          }
        },
      );

  BlocListener<PurchasesBloc, PurchasesState> _restoredListener() =>
      BlocListener<PurchasesBloc, PurchasesState>(
        listenWhen: (p, c) => p.failureOrRestoredOption != c.failureOrRestoredOption,
        listener: (context, state) async {
          if (state.hasRestoredSuccessfully) {
            await context.read<AuthCubit>().refetchUser();
          } else if (state.hasRestoredFailed) {
            await context.handleFailure(state.restoredFailOrCrash);
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MultiBlocListener(
      listeners: [
        _restoringListener(),
        _restoredListener(),
      ],
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: TarotAppBar(
          title: LocaleKeys.settings_page_app_bar.tr(),
          showBackIcon: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: Spacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.largeH,
                _SettingsSection(
                  title: LocaleKeys.settings_page_account.tr(),
                  children: [
                    _SettingsTile(
                      icon: Icons.language,
                      title: LocaleKeys.settings_page_language.tr(),
                      onTap: () => _showLanguageBottomSheet(context),
                    ),
                    _SettingsTile(
                      icon: Icons.star_rate,
                      title: LocaleKeys.settings_page_rate_us.tr(),
                      onTap: () async {
                        await context.read<Launcher>().launchUrl(url: appConfig.appStoreUrl);
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.restore,
                      title: LocaleKeys.settings_page_restore_purchases.tr(),
                      onTap: () {
                        final authState = context.read<AuthCubit>().state;
                        if (authState.isAuthenticated) {
                          final purchaser = authState.userOrCrash.purchaser;
                          context.read<PurchasesBloc>().addPurchasesRestored(
                            purchaser: purchaser,
                            trackingIds: authState.trackingIdsOrNull,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Spacing.largeH,
                _SettingsSection(
                  title: 'Legal',
                  children: [
                    _SettingsTile(
                      icon: Icons.description,
                      title: LocaleKeys.settings_page_terms_of_service.tr(),
                      onTap: () async {
                        await context.read<Launcher>().launchUrlInAppView(
                          url: appConfig.termsOfServiceUrl,
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip,
                      title: LocaleKeys.settings_page_privacy_policy.tr(),
                      onTap: () async {
                        await context.read<Launcher>().launchUrlInAppView(
                          url: appConfig.privacyPolicyUrl,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageBottomSheet(BuildContext context) async {
    final colors = context.colors;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Spacing.largeH,
              Text(
                LocaleKeys.settings_page_choose_language.tr(),
                style: m20w600(context),
              ),
              Spacing.largeH,
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
              Spacing.mediumH,
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
              Spacing.largeH,
            ],
          ),
        );
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.children, this.title});
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: m14w500(context).copyWith(color: colors.textSecondary),
          ),
        ],
        Spacing.smallH,
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: Spacing.defaultBorderRadius,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = colors.textPrimary;

    return ScalingContainer(
      onTap: onTap,
      child: Padding(
        padding: Spacing.defaultPadding,
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            Spacing.mediumW,
            Expanded(
              child: Text(title, style: m16w500(context).copyWith(color: textColor)),
            ),
            Icon(Icons.chevron_right, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        padding: Spacing.defaultPadding,
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: 0.1) : colors.surface,
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(
            color: isSelected ? colors.primary : colors.borderSecondary,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: m16w500(
                  context,
                ).copyWith(color: isSelected ? colors.primary : colors.textPrimary),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
