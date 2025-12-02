import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_datas.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

part '../widgets/library/tarot_library_card_grid.dart';
part '../widgets/library/tarot_library_chip_list.dart';

class TarotLibraryPage extends StatefulWidget {
  const TarotLibraryPage({super.key});

  @override
  State<TarotLibraryPage> createState() => _TarotLibraryPageState();
}

class _TarotLibraryPageState extends State<TarotLibraryPage> {
  late final ValueNotifier<TarotCategory?> selectedCategory;
  late final ValueNotifier<List<TarotLibrary>> filteredCards;

  @override
  void initState() {
    super.initState();
    selectedCategory = ValueNotifier(null);
    filteredCards = ValueNotifier(TarotMockDatas.fullTarotDeckMock);
  }

  @override
  void dispose() {
    selectedCategory.dispose();
    filteredCards.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TarotAppBar(title: 'Library'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary,
                  colors.secondary,
                  colors.accent,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                TarotLibraryChipList(
                  selectedCategory: selectedCategory,
                  filteredCards: filteredCards,
                ),
                Spacing.mediumH,
                TarotCardGridView(filteredCards: filteredCards),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
