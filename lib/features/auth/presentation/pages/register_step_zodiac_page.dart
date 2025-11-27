import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/features/auth/application/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_relationship_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RegisterStep1ZodiacPage extends StatelessWidget {
  const RegisterStep1ZodiacPage({super.key});
  static const route = '/register-step-1-zodiac';

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
              Text(
                'Step 1 of 3',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "What's your zodiac sign?",
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Help us personalize your tarot experience',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.33,
                backgroundColor: colors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: ZodiacSign.values.length,
                      itemBuilder: (context, index) {
                        final zodiac = ZodiacSign.values[index];
                        final isSelected = state.zodiac == zodiac;

                        return _ZodiacCard(
                          zodiac: zodiac,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<RegisterCubit>().selectZodiac(zodiac);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return TarotButton(
                    buttonText: 'Continue',
                    onTap: () {
                      context.goNamed(RegisterStep2RelationshipPage.route);
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

class _ZodiacCard extends StatelessWidget {
  const _ZodiacCard({
    required this.zodiac,
    required this.isSelected,
    required this.onTap,
  });
  final ZodiacSign zodiac;
  final bool isSelected;
  final VoidCallback onTap;

  String _getZodiacEmoji(ZodiacSign zodiac) {
    switch (zodiac) {
      case ZodiacSign.aries:
        return '♈';
      case ZodiacSign.taurus:
        return '♉';
      case ZodiacSign.gemini:
        return '♊';
      case ZodiacSign.cancer:
        return '♋';
      case ZodiacSign.leo:
        return '♌';
      case ZodiacSign.virgo:
        return '♍';
      case ZodiacSign.libra:
        return '♎';
      case ZodiacSign.scorpio:
        return '♏';
      case ZodiacSign.sagittarius:
        return '♐';
      case ZodiacSign.capricorn:
        return '♑';
      case ZodiacSign.aquarius:
        return '♒';
      case ZodiacSign.pisces:
        return '♓';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_getZodiacEmoji(zodiac), style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              zodiac.value,
              style: TextStyle(
                color:
                    isSelected
                        ? colors.textPrimary.withValues(alpha: 0.8)
                        : colors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
