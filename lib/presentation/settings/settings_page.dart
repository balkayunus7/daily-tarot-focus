import 'package:daily_tarot_focus/presentation/core/constants/lyrics_app_sizes.dart';
import 'package:daily_tarot_focus/presentation/core/helper/text_style_helper.dart';
import 'package:daily_tarot_focus/presentation/core/widgets/lyrics_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/popups/core_popup.dart';
import 'package:daily_tarot_focus/config/app_config.dart';
import 'package:daily_tarot_focus/presentation/settings/widgets/paywall_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static void push(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: LyricsAppBar(
        title: 'Settings',
        showBackIcon: true,
        backIcon: Icons.arrow_back_ios,
        onBackIconTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: Spacing.smallPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaywallCard(
              onTap: () {
               // TODO: Implement paywall
              },
            ),
            Spacing.mediumH,
            _SettingsItem(
              icon: Icons.star_border_outlined,
              title: 'Rate the App',
              onTap: () {
                launchUrl(Uri.parse(LyricsAppConfig().appStoreUrl));
              },
            ),
            Spacing.xsmallH,
            _SettingsItem(
              icon: Icons.book_outlined,
              title: 'Terms of Use',
              onTap: () {
                launchUrl(Uri.parse(LyricsAppConfig().termsOfServiceUrl));
              },
            ),
            Spacing.xsmallH,
            _SettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                launchUrl(Uri.parse(LyricsAppConfig().privacyPolicyUrl));
              },
            ),
            Spacing.xsmallH,
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) {
                return previous.showDeleteUserButton !=
                    current.showDeleteUserButton;
              },
              builder: (context, state) {
                if (!state.showDeleteUserButton) {
                  return const SizedBox.shrink();
                }

                return _SettingsItem(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  onTap: () => displayDeleteAccountPopup(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: Spacing.smallBorderRadius,
      child: LiquidGlassLayer(
        settings: LiquidGlassSettings(lightAngle: 0.7, thickness: 70),
        child: LiquidGlass(
          shape: LiquidRoundedRectangle(borderRadius: 16),
          child: Padding(
            padding: Spacing.defaultPadding,
            child: Row(
              children: [
                Container(
                  width: SpacingConsts.xlarge,
                  height: SpacingConsts.xlarge,
                  decoration: BoxDecoration(
                    color: context.colors.secondary,
                    borderRadius: Spacing.circularBorderRadius,
                  ),
                  child: Icon(
                    icon,
                    color: context.colors.primary,
                    size: SpacingConsts.medium,
                  ),
                ),
                Spacing.smallW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(title, style: n14w500(context))],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: Spacing.circularBorderRadius,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.primary,
                    size: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
