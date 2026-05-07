import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/loading_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/loading_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotSpreadLoadingPage extends StatefulWidget {
  const TarotSpreadLoadingPage({super.key});

  @override
  State<TarotSpreadLoadingPage> createState() => _TarotSpreadLoadingPageState();
}

class _TarotSpreadLoadingPageState extends State<TarotSpreadLoadingPage> with LoadingPageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LoadingPageScope(
      state: this,
      child: MultiBlocListener(
        listeners: [
          BlocListener<TarotBloc, TarotState>(
            listenWhen: (previous, current) {
              return !previous.hasGeneratedReadingFailed && current.hasGeneratedReadingFailed;
            },
            listener: (context, state) {
              context
                ..showErrorToastMessage(LocaleKeys.tarot_question_loading_error.tr())
                ..go(AppRoutes.tarotExplore);
            },
          ),
          BlocListener<TarotBloc, TarotState>(
            listenWhen: (previous, current) {
              return !previous.hasGeneratedReadingSucceeded && current.hasGeneratedReadingSucceeded;
            },
            listener: (context, state) {
              context.pushReplacementNamed(AppRoutes.tarotReadingAnswer);
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: colors.background,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.background,
                  colors.primary.withValues(alpha: 0.1),
                  colors.background,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                SizedBox(
                  width: 250.w,
                  height: 250.h,
                  child: Lottie.asset(TarotAppAssets.tarot.path, repeat: true),
                ),
                Sp.large.heightBox,
                ValueListenableBuilder<int>(
                  valueListenable: messageIndex,
                  builder: (context, idx, _) {
                    final scope = LoadingPageScope.of(context).state;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        scope.loadingMessages[idx],
                        key: ValueKey(idx),
                        style: m18w600(context).copyWith(
                          color: colors.primary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                Sp.small.heightBox,
                Text(
                  LocaleKeys.tarot_question_loading_subtitle.tr(),
                  style: m12w400(context).copyWith(
                    color: colors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      backgroundColor: colors.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
