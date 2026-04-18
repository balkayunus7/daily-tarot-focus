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
                label: 'All',
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
    final colors = context.colors;
    final glassColor = isSelected ? colors.secondary : colors.textOnPrimary;
    final borderColor = isSelected ? colors.border : colors.accent;
    final textColor = isSelected ? colors.textOnPrimary : colors.textPrimary;

    return ScalingContainer(
      onTap: onTap,
      child: LiquidGlass.withOwnLayer(
        settings: LiquidGlassSettings(
          glassColor: glassColor,
          blur: 16,
          thickness: 10,
          lightIntensity: isSelected ? 1.1 : 0.7,
        ),
        shape: const LiquidRoundedSuperellipse(borderRadius: Sp.medium),
        child: Container(
          padding: Sp.medium.padHVR(Sp.xsmall),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: Sp.medium.radiusR,
          ),
          child: GlassGlow(
            child: Text(label, style: m12w600(context).copyWith(color: textColor)),
          ),
        ),
      ),
    );
  }
}
