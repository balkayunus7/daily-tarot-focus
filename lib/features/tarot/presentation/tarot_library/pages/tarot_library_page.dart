import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/glass_button.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_library/helpers/library_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../helpers/library_page_mixin.dart';
part '../widgets/library_card_grid.dart';
part '../widgets/library_chip_list.dart';
part '../widgets/library_retry_page.dart';

class TarotLibraryPage extends StatefulWidget {
  const TarotLibraryPage({super.key});

  @override
  State<TarotLibraryPage> createState() => _TarotLibraryPageState();
}

class _TarotLibraryPageState extends State<TarotLibraryPage> with LibraryPageStateMixin {
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
                return Center(child: SpinKitFadingCircle(color: context.colors.primary, size: 32));
              }
              if (state.hasError) {
                return const LibraryRetryWidget();
              }
              return Column(
                children: [
                  const LibraryChipList(),
                  Sp.medium.heightBox,
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
