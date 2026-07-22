import 'dart:async';

import 'package:country_flags/country_flags.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/config/restartable_app.dart';
import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_date_picker.dart';
import 'package:daily_tarot_focus/features/auth/bloc/edit_profile_cubit.dart';
import 'package:daily_tarot_focus/features/auth/data/impl_user_repository.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/personal_info_input_field.dart';
import 'package:daily_tarot_focus/features/core/settings/display_delete_account_popup.dart';
import 'package:daily_tarot_focus/features/core/subscription/premium_override_service.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/application/launcher/launcher.dart';
import 'package:mobile_boilerplate/application/purchases/purchases_bloc.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/core_app.dart';
import 'package:mobile_boilerplate/presentation/common/loading_page.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_failure_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
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
        listenWhen:
            (p, c) => p.failureOrRestoredOption != c.failureOrRestoredOption,
        listener: (context, state) async {
          if (state.hasRestoredSuccessfully) {
            await context.read<AuthCubit>().refetchUser();
          } else if (state.hasRestoredFailed) {
            await context.handleFailure(state.restoredFailOrCrash);
          }
        },
      );

  BlocListener<AuthCubit, AuthState> _deleteAccountListener() =>
      BlocListener<AuthCubit, AuthState>(
        listenWhen:
            (p, c) =>
                p.failOrUserOption.isSome() != c.failOrUserOption.isNone(),
        listener: (context, state) async {
          context.read<TarotBloc>().addClearCache();
        },
      );
  BlocListener<TarotBloc, TarotState> _restartAppListener() =>
      BlocListener<TarotBloc, TarotState>(
        listenWhen: (previous, current) {
          return previous.clearCacheFailureOrUnit.isNone() &&
              current.clearCacheFailureOrUnit.isSome();
        },
        listener: (context, state) async {
          await restartApp(context);
        },
      );

  void _showLanguageBottomSheet(BuildContext context) {
    final colors = context.colors;
    final currentLocale = context.currentLocale;
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: colors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.75,
            ),
            child: Padding(
              padding: Sp.large.padSymR(h: Sp.large, v: Sp.large),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.settings_page_choose_language.tr(),
                    style: m16w600(
                      context,
                    ).copyWith(color: colors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  Sp.large.heightBox,
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _languageOptions.length,
                      separatorBuilder: (_, _) => Sp.small.heightBox,
                      itemBuilder: (_, index) {
                        final option = _languageOptions[index];
                        return _LanguageOption(
                          label: option.label,
                          countryCode: option.countryCode,
                          locale: option.language.locale,
                          isSelected: currentLocale == option.language.locale,
                          onTap: () async {
                            Navigator.of(ctx).pop();
                            await context.setLocale(option.language.locale);
                            if (!context.mounted) return;
                            context.read<TarotBloc>().addClearCache();
                          },
                        );
                      },
                    ),
                  ),
                  Sp.medium.heightBox,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, TarotUser user) {
    final colors = context.colors;
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: colors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (_) => BlocProvider(
              create:
                  (_) => EditProfileCubit(
                    getIt<ImplUserRepository>(),
                    user,
                  ),
              child: _EditProfileSheet(user: user, parentContext: context),
            ),
      ),
    );
  }

  Future<void> restartApp(BuildContext context) async {
    if (context.canPop()) context.pop();
    if (!context.mounted) return;
    context.go(AppRoutes.splash);
    if (!context.mounted) return;
    await RestartableApp.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MultiBlocListener(
      listeners: [
        _restoringListener(),
        _restoredListener(),
        _deleteAccountListener(),
        _restartAppListener(),
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
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final user =
                    authState.isAuthenticated
                        ? authState.userOrCrash as TarotUser
                        : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Sp.large.heightBox,
                    if (user != null) ...[
                      _ProfileSection(
                        user: user,
                        isPremium: PremiumOverrideService.isPremium(
                          user: user,
                          networkTime: context.networkNow(),
                        ),
                        onEditTap: () => _showEditProfileSheet(context, user),
                      ),
                      Sp.large.heightBox,
                    ],
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
                            await context.read<Launcher>().launchUrl(
                              url: appConfig.appStoreUrl,
                            );
                          },
                        ),
                        _SettingsTile(
                          icon: Icons.restore,
                          title:
                              LocaleKeys.settings_page_restore_purchases.tr(),
                          onTap: () {
                            final authState = context.read<AuthCubit>().state;
                            if (authState.isAuthenticated) {
                              final purchaser = authState.userOrCrash.purchaser;
                              context
                                  .read<PurchasesBloc>()
                                  .addPurchasesRestored(
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
                      title: LocaleKeys.settings_page_legal.tr(),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageChoice {
  const _LanguageChoice({
    required this.language,
    required this.label,
    required this.countryCode,
  });

  final LocaleLanguage language;
  final String label;
  final String countryCode;
}

const _languageOptions = [
  _LanguageChoice(
    language: LocaleLanguage.en,
    label: 'English',
    countryCode: 'US',
  ),
  _LanguageChoice(
    language: LocaleLanguage.tr,
    label: 'Türkçe',
    countryCode: 'TR',
  ),
  _LanguageChoice(
    language: LocaleLanguage.es,
    label: 'Español',
    countryCode: 'ES',
  ),
  _LanguageChoice(
    language: LocaleLanguage.pt,
    label: 'Português',
    countryCode: 'BR',
  ),
  _LanguageChoice(
    language: LocaleLanguage.fr,
    label: 'Français',
    countryCode: 'FR',
  ),
  _LanguageChoice(
    language: LocaleLanguage.de,
    label: 'Deutsch',
    countryCode: 'DE',
  ),
  _LanguageChoice(
    language: LocaleLanguage.it,
    label: 'Italiano',
    countryCode: 'IT',
  ),
  _LanguageChoice(language: LocaleLanguage.ja, label: '日本語', countryCode: 'JP'),
  _LanguageChoice(language: LocaleLanguage.ko, label: '한국어', countryCode: 'KR'),
  _LanguageChoice(language: LocaleLanguage.th, label: 'ไทย', countryCode: 'TH'),
  _LanguageChoice(
    language: LocaleLanguage.zhTw,
    label: '繁體中文',
    countryCode: 'TW',
  ),
  _LanguageChoice(
    language: LocaleLanguage.ru,
    label: 'Русский',
    countryCode: 'RU',
  ),
  _LanguageChoice(
    language: LocaleLanguage.zhCn,
    label: '简体中文',
    countryCode: 'CN',
  ),
];

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.user,
    required this.isPremium,
    required this.onEditTap,
  });
  final TarotUser user;
  final bool isPremium;
  final VoidCallback onEditTap;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} / '
        '${date.month.toString().padLeft(2, '0')} / '
        '${date.year}';
  }

  String _formatTime(DateTime date) {
    if (date.hour == 0 && date.minute == 0) return '';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = user.name ?? '';
    final initials =
        name.trim().isNotEmpty
            ? name
                .trim()
                .split(' ')
                .map((w) => w.isNotEmpty ? w[0] : '')
                .take(2)
                .join()
                .toUpperCase()
            : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Sp.xsmall.padXR,
          child: Text(
            LocaleKeys.settings_page_profile.tr(),
            style: m12w600(context).copyWith(color: colors.textTertiary),
          ),
        ),
        Sp.small.heightBox,
        ScalingContainer(
          onTap: onEditTap,
          child: FancyContainer(
            color: colors.primary.withValues(alpha: 0.05),
            border: Border.all(color: colors.border),
            child: Padding(
              padding: Sp.large.padSymR(h: Sp.large, v: Sp.medium),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.gradientStart, colors.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: Sp.medium.radiusR,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: m16w700(context).copyWith(color: colors.accent),
                    ),
                  ),
                  Sp.medium.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (name.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: m16w600(
                                    context,
                                  ).copyWith(color: colors.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isPremium) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        context.colors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                        context.colors.primary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 10.r,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        'Premium',
                                        style: m10w600(context).copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                        if (user.birthDate != null) ...[
                          Sp.tiny.heightBox,
                          Row(
                            children: [
                              Icon(
                                Icons.cake_outlined,
                                size: 13.r,
                                color: colors.textSecondary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDate(user.birthDate!),
                                style: m12w500(
                                  context,
                                ).copyWith(color: colors.textSecondary),
                              ),
                              if (_formatTime(user.birthDate!).isNotEmpty) ...[
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.access_time,
                                  size: 13.r,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  _formatTime(user.birthDate!),
                                  style: m12w500(
                                    context,
                                  ).copyWith(color: colors.textSecondary),
                                ),
                              ],
                            ],
                          ),
                        ],
                        Sp.tiny.heightBox,
                        if (user.relationshipStatus != null ||
                            user.careerStatus != null) ...[
                          Sp.xsmall.heightBox,
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              if (user.relationshipStatus != null) ...[
                                _StatusChip(
                                  label: user.relationshipStatus!.localizedName,
                                ),
                              ],
                              if (user.careerStatus != null) ...[
                                _StatusChip(
                                  label: user.careerStatus!.localizedName,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    color: colors.textSecondary.withValues(alpha: 0.5),
                    size: 18.r,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: Sp.large.radiusR,
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: m11w500(context).copyWith(color: colors.textSecondary),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.user, required this.parentContext});
  final TarotUser user;
  final BuildContext parentContext;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} / '
        '${date.month.toString().padLeft(2, '0')} / '
        '${date.year}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final cubit = context.read<EditProfileCubit>();
    final current = cubit.state.birthDate;
    final picked = await TarotDatePicker.showDate(
      context: context,
      initialDate: current ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null && context.mounted) {
      cubit.setBirthDate(picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final cubit = context.read<EditProfileCubit>();
    final current = cubit.state.birthTime;
    final picked = await TarotDatePicker.showTime(
      context: context,
      initialTime: current ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null && context.mounted) {
      cubit.setBirthTime(picked);
    }
  }

  void _showRelationshipPicker(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<EditProfileCubit>();
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: colors.background,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (_) => BlocProvider.value(
              value: cubit,
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.85,
                builder:
                    (ctx, scrollController) => SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: Sp.large.padSymR(
                              h: Sp.large,
                              v: Sp.medium,
                            ),
                            child: Text(
                              LocaleKeys.settings_page_relationship_label.tr(),
                              style: m16w600(
                                ctx,
                              ).copyWith(color: colors.textPrimary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<
                              EditProfileCubit,
                              EditProfileState
                            >(
                              builder:
                                  (ctx2, state) => ListView.separated(
                                    controller: scrollController,
                                    padding: Sp.large.padSymR(
                                      h: Sp.large,
                                      v: Sp.small,
                                    ),
                                    itemCount: RelationshipStatus.values.length,
                                    separatorBuilder:
                                        (context, index) => Sp.xsmall.heightBox,
                                    itemBuilder: (_, index) {
                                      final status =
                                          RelationshipStatus.values[index];
                                      final isSelected =
                                          state.relationship == status;
                                      return ScalingContainer(
                                        onTap: () {
                                          cubit.setRelationship(status);
                                          Navigator.of(ctx).pop();
                                        },
                                        child: FancyContainer(
                                          color:
                                              isSelected
                                                  ? colors.primary.withValues(
                                                    alpha: 0.15,
                                                  )
                                                  : colors.primary.withValues(
                                                    alpha: 0.05,
                                                  ),
                                          border:
                                              isSelected
                                                  ? Border.all(
                                                    color: colors.primary
                                                        .withValues(alpha: 0.4),
                                                  )
                                                  : Border.all(
                                                    color: colors.border,
                                                  ),
                                          child: Padding(
                                            padding: Sp.small.padSymR(
                                              h: Sp.large,
                                              v: Sp.small,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  status.emoji,
                                                  style: TextStyle(
                                                    fontSize: 18.r,
                                                  ),
                                                ),
                                                Sp.medium.widthBox,
                                                Expanded(
                                                  child: Text(
                                                    status.localizedName,
                                                    style: m14w500(
                                                      ctx2,
                                                    ).copyWith(
                                                      color: colors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: colors.primary,
                                                    size: 18.r,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
      ),
    );
  }

  void _showCareerPicker(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<EditProfileCubit>();
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: colors.background,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (_) => BlocProvider.value(
              value: cubit,
              child: DraggableScrollableSheet(
                expand: false,
                minChildSize: 0.35,
                maxChildSize: 0.8,
                builder:
                    (ctx, scrollController) => SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: Sp.large.padSymR(
                              h: Sp.large,
                              v: Sp.medium,
                            ),
                            child: Text(
                              LocaleKeys.settings_page_career_label.tr(),
                              style: m16w600(
                                ctx,
                              ).copyWith(color: colors.textPrimary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<
                              EditProfileCubit,
                              EditProfileState
                            >(
                              builder:
                                  (ctx2, state) => ListView.separated(
                                    controller: scrollController,
                                    padding: Sp.large.padSymR(
                                      h: Sp.large,
                                      v: Sp.small,
                                    ),
                                    itemCount: CareerStatus.values.length,
                                    separatorBuilder:
                                        (context, index) => Sp.xsmall.heightBox,
                                    itemBuilder: (_, index) {
                                      final status = CareerStatus.values[index];
                                      final isSelected = state.career == status;
                                      return ScalingContainer(
                                        onTap: () {
                                          cubit.setCareer(status);
                                          Navigator.of(ctx).pop();
                                        },
                                        child: FancyContainer(
                                          color:
                                              isSelected
                                                  ? colors.primary.withValues(
                                                    alpha: 0.15,
                                                  )
                                                  : colors.primary.withValues(
                                                    alpha: 0.05,
                                                  ),
                                          border:
                                              isSelected
                                                  ? Border.all(
                                                    color: colors.primary
                                                        .withValues(alpha: 0.4),
                                                  )
                                                  : Border.all(
                                                    color: colors.border,
                                                  ),
                                          child: Padding(
                                            padding: Sp.small.padSymR(
                                              h: Sp.large,
                                              v: Sp.small,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 32.w,
                                                  height: 32.h,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        colors.gradientStart,
                                                        colors.gradientEnd,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        Sp.xsmall.radiusR,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Iconify(
                                                    status.icon,
                                                    color: colors.accent,
                                                    size: 16.r,
                                                  ),
                                                ),
                                                Sp.medium.widthBox,
                                                Expanded(
                                                  child: Text(
                                                    status.localizedName,
                                                    style: m14w500(
                                                      ctx2,
                                                    ).copyWith(
                                                      color: colors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: colors.primary,
                                                    size: 18.r,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final authState = widget.parentContext.read<AuthCubit>().state;
    if (!authState.isAuthenticated) return;
    await context.read<EditProfileCubit>().save(
      session: authState.sessionOrCrash,
      currentUser: widget.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) async {
        if (state.isSuccess) {
          await widget.parentContext.read<AuthCubit>().refetchUser();
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: Sp.large.padSymR(h: Sp.large, v: Sp.large),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.settings_page_edit_profile.tr(),
                    style: m18w700(context).copyWith(color: colors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  Sp.large.heightBox,
                  _sheetLabel(
                    context,
                    LocaleKeys.register_page_name_label.tr(),
                  ),
                  Sp.xsmall.heightBox,
                  PersonalInfoInputField(
                    controller: _nameController,
                    hint: LocaleKeys.register_page_name_hint.tr(),
                    onChanged:
                        (v) => context.read<EditProfileCubit>().setName(v),
                  ),
                  Sp.medium.heightBox,
                  _sheetLabel(
                    context,
                    LocaleKeys.register_page_birth_date_label.tr(),
                  ),
                  Sp.xsmall.heightBox,
                  _PickerField(
                    icon: Mdi.calendar,
                    value:
                        state.birthDate != null
                            ? _formatDate(state.birthDate!)
                            : null,
                    hint: LocaleKeys.register_page_birth_date_hint.tr(),
                    onTap: () => _pickDate(context),
                  ),
                  Sp.medium.heightBox,
                  _sheetLabel(
                    context,
                    LocaleKeys.register_page_birth_time_label.tr(),
                  ),
                  Sp.xsmall.heightBox,
                  _PickerField(
                    icon: Mdi.clock_outline,
                    value: state.birthTime?.format(context),
                    hint: LocaleKeys.register_page_birth_time_hint.tr(),
                    onTap: () => _pickTime(context),
                  ),
                  Sp.medium.heightBox,
                  _sheetLabel(
                    context,
                    LocaleKeys.settings_page_relationship_label.tr(),
                  ),
                  Sp.xsmall.heightBox,
                  _PickerField(
                    icon: Mdi.heart_outline,
                    value:
                        state.relationship != null
                            ? '${state.relationship!.emoji} ${state.relationship!.localizedName}'
                            : null,
                    hint: LocaleKeys.settings_page_relationship_label.tr(),
                    onTap: () => _showRelationshipPicker(context),
                  ),
                  Sp.medium.heightBox,
                  _sheetLabel(
                    context,
                    LocaleKeys.settings_page_career_label.tr(),
                  ),
                  Sp.xsmall.heightBox,
                  _PickerField(
                    icon: Mdi.briefcase_outline,
                    value: state.career?.localizedName,
                    hint: LocaleKeys.settings_page_career_label.tr(),
                    onTap: () => _showCareerPicker(context),
                  ),
                  Sp.xxlarge.heightBox,
                  FancyButton(
                    text: LocaleKeys.common_save.tr(),
                    isLoading: state.isLoading,
                    onTap: () => _save(context),
                  ),
                  Sp.small.heightBox,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sheetLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        label,
        style: m13w600(context).copyWith(
          color: context.colors.textPrimary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.icon,
    required this.hint,
    required this.onTap,
    this.value,
  });

  final String icon;
  final String? value;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = value != null;

    return ScalingContainer(
      onTap: onTap,
      child: FancyContainer(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        color:
            isSelected
                ? colors.primary.withValues(alpha: 0.1)
                : colors.primary.withValues(alpha: 0.05),
        child: Row(
          children: [
            Iconify(
              icon,
              color: isSelected ? colors.primary : colors.textSecondary,
              size: 18.r,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                value ?? hint,
                style: m14w500(context).copyWith(
                  color: isSelected ? colors.textPrimary : colors.textSecondary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color:
                  isSelected
                      ? colors.primary
                      : colors.textSecondary.withValues(alpha: 0.5),
              size: 20.r,
            ),
          ],
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
              style: m12w600(context).copyWith(color: colors.textTertiary),
            ),
          ),
        ],
        Sp.small.heightBox,
        FancyContainer(
          color: colors.primary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[children[i]],
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.countryCode,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String countryCode;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: FancyContainer(
        color:
            isSelected
                ? colors.primary.withValues(alpha: 0.1)
                : colors.primary.withValues(alpha: 0.05),
        border: Border.all(
          color:
              isSelected
                  ? colors.primary.withValues(alpha: 0.5)
                  : colors.border,
        ),
        child: Padding(
          padding: Sp.small.padSymR(h: Sp.large, v: Sp.small),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CountryFlag.fromCountryCode(
                  countryCode,
                  theme: const ImageTheme(height: 20, width: 28),
                ),
              ),
              Sp.medium.widthBox,
              Expanded(
                child: Text(
                  label,
                  style: m14w500(context).copyWith(color: colors.textPrimary),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: colors.primary, size: 20),
            ],
          ),
        ),
      ),
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
                style: m14w500(
                  context,
                ).copyWith(color: color ?? colors.textPrimary),
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
