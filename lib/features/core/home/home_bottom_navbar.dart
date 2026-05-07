import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class HomeBottomNavbar extends StatelessWidget {
  const HomeBottomNavbar({required this.currentIndex, required this.onTap, super.key});
  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final items = TarotMockData.navbarItems;

    return Padding(
      padding: Sp.xxlarge.padHR,
      child: FancyContainer(
        borderRadius: 100,
        width: double.infinity,
        height: 52,
        color: context.colors.textOnPrimary,
        border: Border.all(color: context.colors.primary.withValues(alpha: 0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            final path = items[index]['path']!;
            final label = items[index]['label']!;

            final Widget tabContent = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  path,
                  width: path == TarotAppAssets.tarotIcon.path ? 24 : 16,
                  height: path == TarotAppAssets.tarotIcon.path ? 24 : 16,
                  colorFilter:
                      isSelected
                          ? ColorFilter.mode(context.colors.textOnPrimary, BlendMode.srcIn)
                          : ColorFilter.mode(context.colors.primary, BlendMode.srcIn),
                ),
                Sp.tiny.heightBox,
                Text(
                  label,
                  style: m10w600(context).copyWith(
                    color: isSelected ? context.colors.textOnPrimary : context.colors.primary,
                  ),
                ),
              ],
            );

            Widget tabItem = Container(
              padding: path == TarotAppAssets.tarotIcon.path ? 2.padYR : 6.padYR,
              child: tabContent,
            );

            if (isSelected) {
              tabItem = Container(
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.8),
                  borderRadius: 100.radiusR,
                ),
                child: tabItem,
              );
            }

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Padding(padding: 4.padXR, child: tabItem),
              ),
            );
          }),
        ),
      ),
    );
  }
}
