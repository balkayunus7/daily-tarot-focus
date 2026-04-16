part of '../pages/register_step_relationship_page.dart';

class RelationshipListView extends StatelessWidget {
  const RelationshipListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: RelationshipStatus.values.length,
          separatorBuilder: (_, _) => Sp.small.heightBox,
          itemBuilder: (context, index) {
            final bloc = context.read<RegisterCubit>();
            final status = RelationshipStatus.values[index];
            final isSelected = state.relationshipStatus == status;

            return RelationshipCard(
              status: status,
              isSelected: isSelected,
              onTap: () => bloc.selectRelationshipStatus(status),
            );
          },
        );
      },
    );
  }
}
