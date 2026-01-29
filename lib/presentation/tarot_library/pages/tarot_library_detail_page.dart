import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/base_gradient_layout.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:daily_tarot_focus/presentation/tarot_reveal/pages/tarot_reveal_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotLibraryDetailPage extends StatelessWidget {
  const TarotLibraryDetailPage({required this.tarot, super.key});
  final TarotLibrary tarot;

  @override
  Widget build(BuildContext context) {
    final cardHeight = Spacing.screenHeight(context) * 0.4;

    return BaseGradientLayout(
      appBar: TarotAppBar(title: tarot.title),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: Spacing.largePadding,
            child: Column(
              children: [
                Text(tarot.description, style: m14w500(context)),
                Spacing.largeH,
                Container(
                  height: cardHeight,
                  decoration: BoxDecoration(
                    borderRadius: Spacing.defaultBorderRadius,
                    border: Border.all(color: context.colors.primary, width: 2),
                    boxShadow: context.colors.primary.glowShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: Spacing.smallBorderRadius,
                    child: Image.asset(tarot.imagePath, fit: BoxFit.cover),
                  ),
                ),
                Spacing.largeH,
                DetailDescriptionSection(
                  title: LocaleKeys.libraryMeaningForDay.tr(),
                  descriptions: tarot.meanings,
                  icon: Icons.diamond,
                  iconColor: context.colors.primary,
                ),
                Spacing.largeH,
                DetailDescriptionSection(
                  title: LocaleKeys.libraryUprightMeanings.tr(),
                  descriptions: tarot.uprightMeanings,
                  icon: Icons.check_circle,
                  iconColor: context.colors.correctColor,
                ),
                Spacing.largeH,
                DetailDescriptionSection(
                  title: LocaleKeys.libraryReversedMeanings.tr(),
                  descriptions: tarot.reversedMeanings,
                  icon: Icons.warning,
                  iconColor: context.colors.primary,
                ),
                Spacing.largeH,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
