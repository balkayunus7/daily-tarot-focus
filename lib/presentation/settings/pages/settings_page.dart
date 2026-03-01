import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: TarotAppBar(
        title: LocaleKeys.settingsAppBar.tr(),
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
                title: LocaleKeys.settingsAccount.tr(),
                children: [
                  _SettingsTile(
                    icon: Icons.language,
                    title: LocaleKeys.settingsLanguage.tr(),
                    onTap: () => _showLanguageBottomSheet(context),
                  ),
                  _SettingsTile(
                    icon: Icons.star_rate,
                    title: LocaleKeys.settingsRateUs.tr(),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.restore,
                    title: LocaleKeys.settingsRestorePurchases.tr(),
                    onTap: () {},
                  ),
                ],
              ),
              Spacing.largeH,
              _SettingsSection(
                title: 'Legal',
                children: [
                  _SettingsTile(
                    icon: Icons.description,
                    title: LocaleKeys.settingsTermsOfService.tr(),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip,
                    title: LocaleKeys.settingsPrivacyPolicy.tr(),
                    onTap: () {},
                  ),
                ],
              ),
              const Spacer(),
              _SettingsSection(
                children: [
                  _SettingsTile(
                    icon: Icons.logout,
                    title: LocaleKeys.settingsSignout.tr(),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.delete_forever,
                    title: LocaleKeys.settingsDeleteAccount.tr(),
                    onTap: () {},
                    isDestructive: true,
                  ),
                ],
              ),
              Spacing.mediumH,
            ],
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
                LocaleKeys.settingsChooseLanguage.tr(),
                style: m20w600(context),
              ),
              Spacing.largeH,
              _LanguageOption(
                title: LocaleKeys.settingsEnglish.tr(),
                locale: context.localeEn,
                isSelected: context.isLocaleEn,
                onTap: () async {
                  await context.setLocale(context.localeEn);
                  final langCode = LocaleLanguage.en.value;

                  if (context.mounted) {
                    await context.read<TarotLocalizationCubit>().refreshCards(langCode);
                    if (context.mounted) {
                      final session = context.read<AuthCubit>().state.sessionOrCrash;
                      context.read<TarotBloc>().addDailyCardsFetched(
                        session: session,
                        languageCode: langCode,
                      );
                    }
                  }
                  await HapticFeedbackHelper.selectionClick();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              Spacing.mediumH,
              _LanguageOption(
                title: LocaleKeys.settingsTurkish.tr(),
                locale: context.localeTr,
                isSelected: context.isLocaleTr,
                onTap: () async {
                  await context.setLocale(context.localeTr);
                  final langCode = LocaleLanguage.tr.value;

                  if (context.mounted) {
                    await context.read<TarotLocalizationCubit>().refreshCards(langCode);
                    if (context.mounted) {
                      final session = context.read<AuthCubit>().state.sessionOrCrash;
                      context.read<TarotBloc>().addDailyCardsFetched(
                        session: session,
                        languageCode: langCode,
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
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = isDestructive ? Colors.red : colors.textPrimary;

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
