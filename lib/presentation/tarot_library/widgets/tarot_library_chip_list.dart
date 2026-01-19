part of '../pages/tarot_library_page.dart';

class TarotLibraryChipList extends StatelessWidget {
  const TarotLibraryChipList({
    required this.filteredCards,
    required this.selectedCategory,
    super.key,
  });
  final ValueNotifier<TarotCategory?> selectedCategory;
  final ValueNotifier<List<TarotLibrary>> filteredCards;

  @override
  Widget build(BuildContext context) {
    void handleCategoryChange({required TarotCategory? category}) {
      final fullCards = TarotMockDatas.fullTarotDeckMock;
      if (category == null) {
        selectedCategory.value = null;
        filteredCards.value = fullCards;
        return;
      }
      selectedCategory.value = category;
      filteredCards.value =
          fullCards.where((card) => card.category == category).toList();
    }

    return ValueListenableBuilder(
      valueListenable: selectedCategory,
      builder: (context, value, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              _CategoryChip(
                label: 'All',
                isSelected: selectedCategory.value == null,
                onTap: () {
                  handleCategoryChange(category: null);
                },
              ),
              Spacing.xsmallW,
              ...TarotCategory.values.map(
                (category) {
                  final isSelected = selectedCategory.value == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _CategoryChip(
                      label: category.value,
                      isSelected: isSelected,
                      onTap: () {
                        handleCategoryChange(category: category);
                      },
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? colors.primary
                  : colors.surface.withValues(alpha: 0.1),
          borderRadius: Spacing.largeBorderRadius,
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Text(
          label,
          style: m12w600(context).copyWith(
            color: isSelected ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
