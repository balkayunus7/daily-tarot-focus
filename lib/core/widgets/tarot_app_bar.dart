import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
                  FancyButton(
                    width: 84,
                    height: 38,
                    onTap: () {},
                    text: 'Get Pro',
                    backgroundColor: context.colors.background,
                    textColor: context.colors.textOnPrimary,
                    textStyle: m14w600(context),
                  ),
                  Sp.xsmall.widthBox,
                  ScalingContainer(
                    onTap: () {},
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: context.colors.secondary,
                        borderRadius: 100.radiusR,
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
    this.titleWidget,
  });

  final String? title;
  final Widget? titleWidget;
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
      leading: Builder(
        builder: (context) {
          if (!showBackIcon) return const SizedBox.shrink();
          return ScalingContainer(
            onTap: onBackIconTap ?? () => context.pop(),
            child: Center(
              child: FancyContainer(
                width: 32.w,
                height: 32.h,
                borderRadius: 100,
                color: context.colors.primary,
                child: Icon(
                  backIcon ?? Icons.arrow_back,
                  size: Sp.medium,
                  color: context.colors.textOnPrimary,
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
            onTap: onIconTap ?? () => context.pop(),
            child: AnimatedContainer(
              duration: 300.ms,
              curve: Curves.easeInBack,
              child: Center(
                child: FancyContainer(
                  width: 32.w,
                  height: 32.h,
                  color: context.colors.primary,
                  child: Icon(
                    trailingIcon,
                    size: Sp.medium,
                    color: context.colors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
        Sp.medium.widthBox,
      ],
      title: titleWidget ?? Text(title ?? '', style: titleStyle ?? m21w600(context)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
