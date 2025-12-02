import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotsProAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TarotsProAppBar({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final user = authState.userOrCrash as TarotUser;
    final now = context.networkNow();
    final isPremium = user.isSubscribed(networkTime: now);

    return TarotAppBar(
      title: title,
      centerTitle: false,
      showBackIcon: false,
      subsWidget:
          isPremium
              ? null
              : Row(
                children: [
                  TarotButton(
                    width: 84,
                    height: 38,
                    bgColor: context.colors.primary,
                    onTap: () {},
                    buttonText: 'Get Pro',
                    buttonTextStyle: m14w600(context),
                  ),
                  Spacing.xsmallW,
                  ScalingContainer(
                    onTap: () {},
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: context.colors.surface.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: SvgPicture.asset(TarotAppAssets.settings.path),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TarotAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TarotAppBar({
    super.key,
    this.showBackIcon = true,
    this.onIconTap,
    this.onBackIconTap,
    this.title,
    this.trailingIcon,
    this.subsWidget,
    this.backgroundColor,
    this.backIcon,
    this.centerTitle = true,
    this.titleStyle,
  });

  final String? title;
  final bool showBackIcon;
  final IconData? trailingIcon;
  final Widget? subsWidget;
  final VoidCallback? onIconTap;
  final VoidCallback? onBackIconTap;
  final IconData? backIcon;
  final Color? backgroundColor;
  final bool centerTitle;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      leadingWidth: 0,
      leading: Builder(
        builder: (context) {
          if (!showBackIcon) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ScalingContainer(
              onTap: onBackIconTap ?? () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: context.colors.border),
                  color: context.colors.surface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(
                    backIcon ?? Icons.arrow_back_ios,
                    size: 24,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      actions: [
        if (subsWidget != null) ...[subsWidget!],
        if (trailingIcon != null) ...[
          ScalingContainer(
            onTap: onIconTap ?? () => Navigator.pop(context),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Icon(
                  trailingIcon,
                  size: 24,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ),
        ],
        Spacing.mediumW,
      ],
      title: Text(title ?? '', style: titleStyle ?? m21w600(context)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
