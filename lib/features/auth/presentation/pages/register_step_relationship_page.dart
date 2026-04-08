import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/features/auth/bloc/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
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
                LocaleKeys.register_page_step_2_of_3.tr(),
                style: m14w400(context).copyWith(color: colors.textSecondary),
              ),
              Spacing.xsmallH,
              Text(
                LocaleKeys.register_page_relationship_title.tr(),
                style: m32w600(context),
              ),
              Spacing.xsmallH,
              Text(
                LocaleKeys.register_page_relationship_subtitle.tr(),
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
                    buttonText: LocaleKeys.register_page_continue_button.tr(),
                    onTap: () async {
                      await context.push(AppRoutes.registerStepBirthdate);
                    },
                    bgColor: colors.primary,
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
