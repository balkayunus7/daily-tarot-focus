import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/features/auth/application/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_birthdate_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RegisterStep2RelationshipPage extends StatelessWidget {
  const RegisterStep2RelationshipPage({super.key});
  static const route = '/register-step-2-relationship';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Step 2 of 3',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "What's your relationship status?",
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us provide better insights',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.66,
                backgroundColor: colors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return ListView.separated(
                      itemCount: RelationshipStatus.values.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final status = RelationshipStatus.values[index];
                        final isSelected = state.relationshipStatus == status;

                        return _RelationshipCard(
                          status: status,
                          isSelected: isSelected,
                          onTap: () {
                            context
                                .read<RegisterCubit>()
                                .selectRelationshipStatus(status);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return TarotButton(
                    buttonText: 'Continue',
                    onTap: () async {
                      await context.pushNamed(RegisterStep3BirthdatePage.route);
                    },
                    buttonTextStyle: n16w700(context),
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

class _RelationshipCard extends StatelessWidget {
  const _RelationshipCard({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });
  
  final RelationshipStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? colors.primary.withValues(alpha: 0.15)
                  : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(status.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                status.value,
                style: TextStyle(
                  color: isSelected ? colors.primary : colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
