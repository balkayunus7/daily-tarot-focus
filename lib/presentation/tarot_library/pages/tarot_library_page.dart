import 'package:daily_tarot_focus/application/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/tarot_library/helpers/library_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/library_card_grid.dart';
part '../widgets/library_chip_list.dart';
part '../helpers/library_page_mixin.dart';

class TarotDataPage extends StatefulWidget {
  const TarotDataPage({super.key});

  @override
  State<TarotDataPage> createState() => _TarotDataPageState();
}

class _TarotDataPageState extends State<TarotDataPage> with LibraryPageStateMixin {
  @override
  Widget build(BuildContext context) {
    return LibraryPageScope(
      state: this,
      child: Scaffold(
        appBar: TarotAppBar(title: LocaleKeys.library_page_title.tr()),
        body: SafeArea(
          child: BlocBuilder<TarotLocalizationCubit, TarotLocalizationState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.hasError) {
                return Center(child: Text(state.errorMessage ?? 'Error loading cards'));
              }

              return Column(
                children: [
                  const LibraryChipList(),
                  Spacing.mediumH,
                  LibraryCardGridView(filteredCards: state.filteredCards),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
