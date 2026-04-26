import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/presentation/bottom_sheets/core_bottom_sheet.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

Future<void> showSpreadDetailsBottomSheet(
  BuildContext context,
  TarotSpreadModel spread,
  VoidCallback onTap,
) async {
  await showCoreBottomSheet(
    context,
    backgroundColor: context.colors.surface,
    buildWidget: (bottomSheetContext) {
      return SafeArea(
        child: Column(
          children: [
            Text(spread.title, style: m16w700(bottomSheetContext), textAlign: TextAlign.center),
            Sp.medium.heightBox,
            Divider(color: bottomSheetContext.colors.border),
            Sp.large.heightBox,
            ...spread.positions.asList().map((position) {
              return Padding(
                padding: Sp.small.padSymR(h: Sp.large, v: Sp.xsmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Card ${position.index}: ', style: m14w700(bottomSheetContext)),
                    Sp.tiny.widthBox,
                    Expanded(
                      child: Text(
                        position.question.isNotEmpty ? position.question : position.title,
                        style: m14w400(bottomSheetContext),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Sp.xlarge.heightBox,
            Wrap(
              spacing: Sp.small,
              runSpacing: Sp.small,
              alignment: WrapAlignment.center,
              children:
                  spread.positions.asList().map((position) {
                    return Container(
                      width: 40.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: bottomSheetContext.colors.border),
                        borderRadius: Sp.xsmall.radiusR,
                        color: bottomSheetContext.colors.primary.withValues(alpha: 0.05),
                      ),
                      child: Center(
                        child: Text('${position.index}', style: m16w700(bottomSheetContext)),
                      ),
                    );
                  }).toList(),
            ),
            Sp.xlarge.heightBox,
            FancyButton(
              onTap: onTap,
              text: 'Tap to Draw Cards',
              padding: Sp.large.padXR,
            ),
          ],
        ),
      );
    },
  );
}
