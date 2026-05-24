part of '../pages/tarot_explore_page.dart';

class ExploreNumerologyCard extends StatelessWidget {
  const ExploreNumerologyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen:
          (previous, current) => previous.userOrCrash != current.userOrCrash,
      builder: (context, state) {
        final user = state.userOrCrash as TarotUser;
        final birthDate = user.birthDate;
        final fullName = user.name?.trim() ?? '';

        return ExploreFeatureCard(
          title: LocaleKeys.numerology_page_explore_card_title.tr(),
          imageWidget: const NumerologyIllustration(),
          onTap: () {
            if (birthDate != null && fullName.isNotEmpty) {
              unawaited(
                context.push(
                  AppRoutes.numerologyResult,
                  extra: NumerologyResultArgs(
                    birthDate: birthDate,
                    fullName: fullName,
                  ),
                ),
              );
            } else {
              unawaited(
                context.push(
                  AppRoutes.numerologyInput,
                  extra: const NumerologyInputArgs(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
