import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/base_gradient_layout.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:daily_tarot_focus/presentation/tarot_library/helpers/library_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../../tarot_library/widgets/tarot_library_card_grid.dart';
part '../../tarot_library/widgets/tarot_library_chip_list.dart';
part '../helpers/library_page_mixin.dart';

class TarotLibraryPage extends StatefulWidget {
  const TarotLibraryPage({super.key});

  @override
  State<TarotLibraryPage> createState() => _TarotLibraryPageState();
}

class _TarotLibraryPageState extends State<TarotLibraryPage>
    with LibraryPageStateMixin {
  @override
  Widget build(BuildContext context) {
    return TarotLibraryScope(
      selectedCategory: selectedCategory,
      filteredCards: filteredCards,
      onCategoryChanged: onCategoryChanged,
      child: BaseGradientLayout(
        appBar: TarotAppBar(title: LocaleKeys.libraryTitle.tr()),
        child: SafeArea(
          child: Column(
            children: [
              const TarotLibraryChipList(),
              Spacing.mediumH,
              TarotCardGridView(filteredCards: filteredCards),
            ],
          ),
        ),
      ),
    );
  }
}
