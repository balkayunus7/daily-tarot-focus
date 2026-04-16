import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/glass_button.dart';
import 'package:daily_tarot_focus/core/widgets/glass_container.dart';
import 'package:daily_tarot_focus/features/auth/bloc/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/step_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/zodiac_item.dart';
part '../widgets/zodiac_grid.dart';

class RegisterStepZodiacPage extends StatelessWidget {
  const RegisterStepZodiacPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          const StepBackground(),
          SafeArea(
            child: Padding(
              padding: Sp.screen.padAllR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.register_page_step_1_of_3.tr(),
                    style: m14w700(context).copyWith(color: colors.textSecondary),
                  ),
                  Sp.xsmall.heightBox,
                  Text(
                    LocaleKeys.register_page_zodiac_title.tr(),
                    style: m32w600(context),
                  ),
                  Sp.xsmall.heightBox,
                  Text(
                    LocaleKeys.register_page_zodiac_subtitle.tr(),
                    style: m16w500(context).copyWith(color: colors.textSecondary),
                  ),
                  Sp.small.heightBox,
                  LinearProgressIndicator(
                    value: 0.33,
                    minHeight: 6,
                    borderRadius: Sp.medium.radiusR,
                    backgroundColor: colors.secondary,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                  Sp.xxlarge.heightBox,
                  const Expanded(child: ZodiacGrid()),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return GlassButton(
                        buttonText: LocaleKeys.register_page_continue_button.tr(),
                        onTap: () async {
                          await context.push(AppRoutes.registerStepRelationship);
                        },
                        isDisabled: !state.isZodiacSelected,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
