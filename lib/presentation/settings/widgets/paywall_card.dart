import 'package:daily_tarot_focus/presentation/core/helper/text_style_helper.dart';
import 'package:daily_tarot_focus/presentation/core/widgets/lyrics_button.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/app_text_styles.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_period.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:daily_tarot_focus/presentation/core/constants/lyrics_app_sizes.dart';

class PaywallCard extends StatefulWidget {
  const PaywallCard({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<PaywallCard> createState() => _PaywallCardState();
}

class _PaywallCardState extends State<PaywallCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current.isAuthenticated,
      builder: (context, state) {
        final now = context.networkNow();
        final user = state.userOrCrash;
        final isPrem = user.isSubscribed(networkTime: now);
        final expAt = user.subscription?.expiresAt ?? context.networkNow();
        final expiresAtString = expAt.dAmY(context.locale);

        return LiquidGlassLayer(
          settings: LiquidGlassSettings(lightAngle: 0.7, thickness: 70),
          child: LiquidGlass(
            shape: LiquidRoundedRectangle(borderRadius: 16),
            child: Padding(
              padding: Spacing.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '⭐  Premium',
                        style: AppTextStyles.heading3(context).copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacing.smallH,
                  if (!isPrem) ...[
                    Text(
                      "With Premium, exploration becomes limitless and even more exciting! Identify every species, discover detailed insights, and personalize your ocean journey with your own notes.",
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: context.colors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    Spacing.xlargeH,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: SpacingConsts.small,
                      children: [
                        _ContainerItem(text: 'Unlimited fish scans'),
                        _ContainerItem(
                          text: 'View popular species in your area',
                        ),
                        _ContainerItem(text: 'Add personal notes when saving'),
                      ],
                    ),
                    Spacing.xlargeH,
                    LyricsButton(
                      onTap: widget.onTap,
                      buttonText: 'Upgrade to Premium',
                      bgColor: context.colors.primary,
                      buttonTextStyle: n16w700(context),
                    ),
                  ] else ...[
                    Builder(
                      builder: (context) {
                        final user =
                            context.read<AuthCubit>().state.userOrCrash;
                        return Text(
                          user.subscription!.period !=
                                  SubscriptionPeriod.lifetime
                              ? 'Your subscription will expire on $expiresAtString '
                              : 'Your subscription never expires!',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ContainerItem extends StatelessWidget {
  const _ContainerItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: context.colors.primary,
          size: SpacingConsts.large,
        ),
        Spacing.xsmallW,
        Text(
          text,
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: context.colors.textPrimary),
        ),
      ],
    );
  }
}
