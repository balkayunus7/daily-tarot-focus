part of '../pages/register_step_zodiac_page.dart';

class ZodiacGrid extends StatelessWidget {
  const ZodiacGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: SpacingConsts.small,
            mainAxisSpacing: SpacingConsts.small,
          ),
          itemCount: ZodiacSign.values.length,
          itemBuilder: (context, index) {
            final zodiac = ZodiacSign.values[index];
            final isSelected = state.zodiac == zodiac;
            final bloc = context.read<RegisterCubit>();

            return ZodiacCard(
              zodiac: zodiac,
              isSelected: isSelected,
              onTap: () {
                bloc.selectZodiac(zodiac);
              },
            );
          },
        );
      },
    );
  }
}
