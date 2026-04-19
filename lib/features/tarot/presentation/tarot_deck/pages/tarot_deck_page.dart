import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/glass_button.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_deck/helpers/deck_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../helpers/deck_page_mixin.dart';
part '../widgets/deck_card_grid.dart';
part '../widgets/deck_chip_list.dart';
part '../widgets/deck_retry_page.dart';

class TarotDeckPage extends StatefulWidget {
  const TarotDeckPage({super.key});

  @override
  State<TarotDeckPage> createState() => _TarotDeckPageState();
}

class _TarotDeckPageState extends State<TarotDeckPage> with DeckPageStateMixin {
  @override
  Widget build(BuildContext context) {
    return DeckPageScope(
      state: this,
      child: Scaffold(
        appBar: TarotAppBar(title: LocaleKeys.deck_page_title.tr()),
        body: SafeArea(
          child: ValueListenableBuilder<TarotCategory?>(
            valueListenable: selectedCategory,
            builder: (context, category, child) {
              return BlocBuilder<TarotBloc, TarotState>(
                builder: (context, state) {
                  final filteredCards = state.byCategory(category);

                  return Column(
                    children: [
                      const DeckChipList(),
                      Sp.medium.heightBox,
                      DeckCardGridView(filteredCards: filteredCards),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
