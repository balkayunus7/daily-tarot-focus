import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/auth/presentation/helpers/account_setup_mixin.dart';
import 'package:daily_tarot_focus/features/auth/presentation/helpers/account_setup_scope.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/step_background.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RegisterAccountSetupPage extends StatefulWidget {
  const RegisterAccountSetupPage({super.key});

  @override
  State<RegisterAccountSetupPage> createState() => _RegisterAccountSetupPageState();
}

class _RegisterAccountSetupPageState extends State<RegisterAccountSetupPage>
    with AccountSetupMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final tarotBloc = context.read<TarotBloc>();
      if (tarotBloc.state.hasAccountSetupCompleted) {
        precacheImages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AccountSetupScope(
      state: this,
      child: Scaffold(
        backgroundColor: colors.background,
        body: Stack(
          children: [
            const StepBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ValueListenableBuilder<double>(
                  valueListenable: progress,
                  builder: (context, progressValue, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: isPrecaching,
                      builder: (context, precaching, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.register_page_preparing_account.tr(),
                              style: m26w600(context),
                            ),
                            Sp.xsmall.heightBox,
                            Text(
                              precaching
                                  ? LocaleKeys.register_page_loading_images.tr()
                                  : LocaleKeys.register_page_loading_data.tr(),
                              style: m12w500(context).copyWith(color: colors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            Sp.xlarge.heightBox,
                            LinearProgressIndicator(
                              value: progressValue,
                              minHeight: 8,
                              borderRadius: Sp.xsmall.radiusR,
                              backgroundColor: colors.accent,
                              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                            ),
                            Sp.medium.heightBox,
                            Text(
                              LocaleKeys.register_page_progress_format.tr(
                                args: [(progressValue * 100).toInt().toString()],
                              ),
                              style: m14w700(context).copyWith(color: colors.secondary),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
