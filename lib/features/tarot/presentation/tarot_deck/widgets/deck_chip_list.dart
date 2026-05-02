part of '../pages/tarot_deck_page.dart';

class DeckChipList extends StatelessWidget {
  const DeckChipList({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = DeckPageScope.of(context);

    return ValueListenableBuilder<TarotCategory?>(
      valueListenable: scope.state.selectedCategory,
      builder: (context, category, child) {
        final isCategoryAllSelected = category == null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: Sp.medium.padHVR(Sp.small),
          child: Row(
            children: [
              _CategoryChip(
                label: LocaleKeys.deck_page_all.tr(),
                isSelected: isCategoryAllSelected,
                onTap: () => scope.state.onCategoryChanged = null,
              ),
              Sp.xsmall.widthBox,
              ...TarotCategory.values.map((cat) {
                final isSelected = cat == category;
                return Padding(
                  padding: Sp.xsmall.padRightR,
                  child: _CategoryChip(
                    label: cat.value,
                    isSelected: isSelected,
                    onTap: () => scope.state.onCategoryChanged = cat,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScalingContainer(
      onTap: onTap,
      child: FancyContainer(
        padding: Sp.tiny.padSymR(h: Sp.small, v: Sp.xsmall),
        border: Border.all(color: context.colors.border, width: 0.5),
        color: isSelected ? context.colors.primary : context.colors.primary.withValues(alpha: 0.2),
        child: Text(label, style: m10w600(context).copyWith(color: context.colors.textOnPrimary)),
      ),
    );
  }
}
