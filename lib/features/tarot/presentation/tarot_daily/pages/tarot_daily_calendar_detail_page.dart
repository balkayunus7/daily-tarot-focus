import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/widgets/daily_pick_result_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotDailyCalendarDetailArgs {
  const TarotDailyCalendarDetailArgs({
    required this.tarot,
    required this.dailyCard,
  });

  final TarotCardModel tarot;
  final DailyCardModel dailyCard;
}

class TarotDailyCalendarDetailPage extends StatelessWidget {
  const TarotDailyCalendarDetailPage({required this.args, super.key});
  final TarotDailyCalendarDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dailyCard = args.dailyCard;
    final hasContent =
        dailyCard.dailyAdvice != null || dailyCard.categories.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TarotAppBar(
              title: LocaleKeys.daily_pick_page_title.tr(),
              titleStyle: m18w700(context),
              onBackIconTap: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  0,
                  Sp.large.h,
                  0,
                  Sp.xxxlarge.h + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DailyPickDetailTop(
                      tarot: args.tarot,
                      isReversed: dailyCard.isReversed,
                      date: dailyCard.date,
                    ),
                    if (hasContent) ...[
                      Sp.xlarge.heightBox,
                      Padding(
                        padding: Sp.xlarge.padXR,
                        child: Column(
                          children: [
                            if (dailyCard.dailyAdvice != null)
                              DailyPickAdviceCard(text: dailyCard.dailyAdvice!),
                            if (dailyCard.categories.isNotEmpty) ...[
                              Sp.medium.heightBox,
                              ...dailyCard.categories.map(
                                (category) => Padding(
                                  padding: EdgeInsets.only(bottom: Sp.medium.h),
                                  child: DailyPickCategoryTile(
                                    category: category,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
