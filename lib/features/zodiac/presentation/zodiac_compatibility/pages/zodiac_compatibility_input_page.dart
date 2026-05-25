import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_compatibility/helpers/zodiac_compatibility_page_mixin.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_compatibility/helpers/zodiac_compatibility_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/input_gender_picker.dart';
part '../widgets/input_zodiac_picker.dart';

class TarotCompatibilityInputPage extends StatefulWidget {
  const TarotCompatibilityInputPage({super.key});

  @override
  State<TarotCompatibilityInputPage> createState() =>
      _TarotCompatibilityInputPageState();
}

class _TarotCompatibilityInputPageState
    extends State<TarotCompatibilityInputPage>
    with SingleTickerProviderStateMixin, ZodiacCompatibilityPageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return wrapWithRestartListener(
      context,
      Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TarotAppBar(
                title: LocaleKeys.compat_page_title.tr(),
                titleStyle: m18w700(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: Sp.large.padSymR(h: Sp.large.w, v: Sp.large.h),
                  child: Column(
                    children: [
                      _PersonSection(
                        label: LocaleKeys.compat_page_you.tr(),
                        isMe: true,
                      ),
                      Sp.xlarge.heightBox,
                      _PersonSection(
                        label: LocaleKeys.compat_page_partner.tr(),
                        isMe: false,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Sp.screen.w,
                  Sp.medium.h,
                  Sp.screen.w,
                  Sp.large.h + MediaQuery.of(context).padding.bottom,
                ),
                child: FancyButton(
                  width: double.infinity,
                  height: 52.h,
                  text: LocaleKeys.compat_page_calculate.tr(),
                  textStyle: m16w700(
                    context,
                  ).copyWith(color: colors.textOnPrimary),
                  onTap: () {
                    final request = buildRequest();
                    unawaited(
                      context.push(
                        AppRoutes.tarotCompatibilityResult,
                        extra: request,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonSection extends StatelessWidget {
  const _PersonSection({required this.label, required this.isMe});
  final String label;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ZodiacCompatibilityPageScope(
      state:
          context.findAncestorStateOfType<_TarotCompatibilityInputPageState>()!,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: Sp.large.radiusR,
          border: Border.all(color: colors.border),
        ),
        padding: Sp.large.padAllR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: m18w700(context)),
            Sp.medium.heightBox,
            ZodiacPicker(isMe: isMe),
            Sp.large.heightBox,
            GenderPicker(isMe: isMe),
          ],
        ),
      ),
    );
  }
}
