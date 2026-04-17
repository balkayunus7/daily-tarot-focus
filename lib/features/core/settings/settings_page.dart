import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/glass_container.dart';
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
import 'package:mobile_boilerplate/presentation/popups/core_popup.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part 'change_language_dialog.dart';

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
          child: SingleChildScrollView(
            padding: Sp.screen.padHR,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Sp.large.heightBox,
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
                Sp.large.heightBox,
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
                Sp.large.heightBox,
                _SettingsSection(
                  title: 'Danger Zone',
                  children: [
                    _SettingsTile(
                      icon: Icons.delete_forever,
                      title: LocaleKeys.settings_page_delete_account.tr(),
                      color: colors.error,
                      onTap: () => displayDeleteAccountPopup(context),
                    ),
                  ],
                ),
                Sp.xxlarge.heightBox,
              ],
            ),
          ),
        ),
      ),
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
          Padding(
            padding: Sp.xsmall.padXR,
            child: Text(
              title!.toUpperCase(),
              style: m12w600(context).copyWith(
                color: colors.textSecondary.withValues(alpha: 0.6),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
        Sp.small.heightBox,
        GlassContainer(
          borderRadius: Sp.medium,
          glassColor: colors.primary.withValues(alpha: 0.05),
          borderColor: colors.primary.withValues(alpha: 0.05),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
              ],
            ],
          ),
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
    this.color,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: Padding(
        padding: Sp.small.padSymR(h: Sp.large, v: Sp.small),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.gradientStart, colors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: Sp.small.radiusR,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: colors.accent, size: 18),
            ),
            Sp.medium.widthBox,
            Expanded(
              child: Text(
                title,
                style: m15w500(context).copyWith(color: color ?? colors.textPrimary),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: (color ?? colors.textSecondary).withValues(alpha: 0.4),
              size: 20,
            ),
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
      child: GlassContainer(
        padding: Sp.small.padSymR(h: Sp.large, v: Sp.small),
        borderRadius: Sp.medium,
        glassColor:
            isSelected
                ? colors.primary.withValues(alpha: 0.2)
                : colors.primary.withValues(alpha: 0.05),
        borderColor: colors.primary.withValues(alpha: 0.05),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: m15w600(context).copyWith(
                  color: isSelected ? colors.primary : colors.textPrimary,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: colors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
