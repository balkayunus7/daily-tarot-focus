part of '../pages/tarot_library_page.dart';

class LibraryChipList extends StatelessWidget {
  const LibraryChipList({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = LibraryPageScope.of(context);

    return BlocBuilder<TarotLocalizationCubit, TarotLocalizationState>(
      builder: (context, state) {
        final currentCategory = state.selectedCategory;
        final isCategoryAllSelected = currentCategory == null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: Spacing.hMediumVSmallPad,
          child: Row(
            children: [
              _CategoryChip(
                label: 'All',
                isSelected: isCategoryAllSelected,
                onTap: () => scope.state.onCategoryChanged(null),
              ),
              Spacing.xsmallW,
              ...TarotCategory.values.map(
                (category) {
                  final isSelected = currentCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: SpacingConsts.xsmall),
                    child: _CategoryChip(
                      label: category.value,
                      isSelected: isSelected,
                      onTap: () => scope.state.onCategoryChanged(category),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textPrimary = colors.textPrimary;
    final bgColor = isSelected ? colors.primary : colors.textFieldBg;
    final borderColor = isSelected ? colors.primary : colors.surfaceSecondary;
    final textColor = isSelected ? textPrimary : textPrimary.withAlpha(500);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: Spacing.hMediumVSmallPad,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: Spacing.largeBorderRadius,
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: m12w600(context).copyWith(color: textColor),
        ),
      ),
    );
  }
}
