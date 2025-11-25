import 'package:daily_tarot_focus/features/auth/domain/entities/tarot_user.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotsProAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TarotsProAppBar({super.key, required this.title});
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
                    onTap: () {
                      // TODO: Implement paywall
                    },
                    buttonText: 'Get Pro',
                    buttonTextStyle: n14w600(context),
                  ),
                  Spacing.xsmallW,
                  LiquidGlassLayer(
                    settings: const LiquidGlassSettings(lightAngle: 0.3),
                    child: ScalingContainer(
                      onTap: () {
                        SettingsPage.push(context);
                      },
                      child: LiquidGlass(
                        shape: LiquidRoundedRectangle(borderRadius: 100),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: context.colors.surface.withValues(
                              alpha: 0.04,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              TarotAppAssets.settings.path,
                            ),
                          ),
                        ),
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
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
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
                    backIcon ?? Icons.arrow_back,
                    size: 18,
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
                  trailingIcon,
                  size: 20,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ),
        ],
        Spacing.mediumW,
      ],
      title: Text(title ?? '', style: titleStyle ?? n18w700(context)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
