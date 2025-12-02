import 'package:daily_tarot_focus/application/auth/register_cubit.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user_relations_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/relationship_card.dart';
part '../widgets/relationship_listview.dart';

class RegisterStepRelationshipPage extends StatelessWidget {
  const RegisterStepRelationshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: Spacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 2 of 3',
                style: m14w400(context).copyWith(color: colors.textSecondary),
              ),
              Spacing.xsmallH,
              Text(
                "What's your relationship status?",
                style: m32w600(context),
              ),
              Spacing.xsmallH,
              Text(
                'This helps us provide better insights',
                style: m16w400(context).copyWith(color: colors.textSecondary),
              ),
              Spacing.smallH,
              LinearProgressIndicator(
                value: 0.66,
                backgroundColor: colors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
              Spacing.xxlargeH,
              const Expanded(child: RelationshipListView()),
              Spacing.xxlargeH,
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return TarotButton(
                    buttonText: 'Continue',
                    onTap: () async {
                      await context.push(AppRoutes.registerStepBirthdate);
                    },
                    buttonTextStyle: m16w700(context),
                    isDisabled: !state.isRelationshipStatusSelected,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
