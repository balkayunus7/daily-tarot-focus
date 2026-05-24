import 'dart:async';
import 'dart:math' as math;

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/data/daily_spread_usage_service.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/loading_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/loading_page_scope.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/tarot_cards_loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';

class TarotSpreadLoadingPage extends StatefulWidget {
  const TarotSpreadLoadingPage({super.key});

  @override
  State<TarotSpreadLoadingPage> createState() => _TarotSpreadLoadingPageState();
}

class _TarotSpreadLoadingPageState extends State<TarotSpreadLoadingPage>
    with LoadingPageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LoadingPageScope(
      state: this,
      child: PopScope(
        canPop: false,
        child: MultiBlocListener(
          listeners: [
            BlocListener<TarotBloc, TarotState>(
              listenWhen: (previous, current) {
                return !previous.hasGeneratedReadingFailed &&
                    current.hasGeneratedReadingFailed;
              },
              listener: (context, state) {
                context
                  ..showErrorToastMessage(
                    LocaleKeys.tarot_question_loading_error.tr(),
                  )
                  ..go(AppRoutes.tarotExplore);
              },
            ),
            BlocListener<TarotBloc, TarotState>(
              listenWhen: (previous, current) {
                return !previous.hasGeneratedReadingSucceeded &&
                    current.hasGeneratedReadingSucceeded;
              },
              listener: (context, state) {
                final user =
                    context.read<AuthCubit>().state.userOrCrash as TarotUser;
                unawaited(
                  DailySpreadUsageService.increment(
                    userId: user.userId,
                    date: context.networkNow(),
                  ),
                );
                context.pushReplacementNamed(AppRoutes.tarotReadingAnswer);
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: colors.background,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.background,
                          colors.primary.withValues(alpha: 0.08),
                          colors.background,
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    TarotCardsLoadingAnimation(size: 220.w),
                    Sp.large.heightBox,
                    ValueListenableBuilder<int>(
                      valueListenable: messageIndex,
                      builder: (context, idx, _) {
                        final scope = LoadingPageScope.of(context).state;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.25),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: child,
                              ),
                            );
                          },
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
                    _DotsProgressIndicator(color: colors.primary),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DotsProgressIndicator extends StatefulWidget {
  const _DotsProgressIndicator({required this.color});
  final Color color;

  @override
  State<_DotsProgressIndicator> createState() => _DotsProgressIndicatorState();
}

class _DotsProgressIndicatorState extends State<_DotsProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            final delay = i / 5.0;
            final raw = (_controller.value - delay) % 1.0;
            final t = math.sin(raw * math.pi).clamp(0.0, 1.0);
            final scale = 0.45 + 0.55 * t;
            final opacity = 0.25 + 0.75 * t;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 9.w,
                    height: 9.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.45 * t),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
