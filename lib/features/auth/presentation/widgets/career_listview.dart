part of '../pages/register_step_career_page.dart';

class CareerListView extends StatelessWidget {
  const CareerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return ListView.separated(
          padding: Sp.xxxlarge.padOnlyR(b: true),
          itemCount: CareerStatus.values.length,
          separatorBuilder: (_, _) => Sp.small.heightBox,
          itemBuilder: (context, index) {
            final bloc = context.read<RegisterCubit>();
            final status = CareerStatus.values[index];
            final isSelected = state.careerStatus == status;

            return CareerItem(
              status: status,
              isSelected: isSelected,
              onTap: () => bloc.selectCareerStatus(status),
            );
          },
        );
      },
    );
  }
}
