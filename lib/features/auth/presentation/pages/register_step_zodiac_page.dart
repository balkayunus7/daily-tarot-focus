import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/auth/bloc/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/auth/presentation/helpers/account_setup_mixin.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/step_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/zodiac_item.dart';
part '../widgets/zodiac_grid.dart';

class RegisterStepZodiacPage extends StatefulWidget {
  const RegisterStepZodiacPage({super.key});

  @override
  State<RegisterStepZodiacPage> createState() => _RegisterStepZodiacPageState();
}

class _RegisterStepZodiacPageState extends State<RegisterStepZodiacPage> with AccountSetupMixin {
  @override
  bool get shouldAutoNavigate => false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImages();
    });
  }

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
                    style: m14w500(context).copyWith(color: colors.textSecondary),
                  ),
                  Sp.small.heightBox,
                  LinearProgressIndicator(
                    value: 0.33,
                    minHeight: 6,
                    borderRadius: Sp.medium.radiusR,
                    backgroundColor: colors.accent,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                  Sp.xxlarge.heightBox,
                  const Expanded(child: ZodiacGrid()),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return FancyButton(
                        text: LocaleKeys.register_page_continue_button.tr(),
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
