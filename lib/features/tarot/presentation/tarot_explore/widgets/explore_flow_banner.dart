part of '../pages/tarot_explore_page.dart';

/// Explains, on first open, how the on-device Planetary Hours computation
/// feeds the day's timing, recommendations, guidance and daily card - the
/// app's core mechanic, ahead of anything tarot-specific.
class ExploreFlowBanner extends StatelessWidget {
  const ExploreFlowBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final steps = [
      LocaleKeys.explore_page_flow_step_planetary.tr(),
      LocaleKeys.explore_page_flow_step_timing.tr(),
      LocaleKeys.explore_page_flow_step_recommendation.tr(),
      LocaleKeys.explore_page_flow_step_guidance.tr(),
      LocaleKeys.explore_page_flow_step_card.tr(),
    ];

    return FancyContainer(
      color: colors.surface,
      padding: Sp.medium.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.explore_page_flow_title.tr(),
            style: m13w600(context),
          ),
          Sp.small.heightBox,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0) ...[
                    Sp.tiny.widthBox,
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14.r,
                      color: colors.textSecondary,
                    ),
                    Sp.tiny.widthBox,
                  ],
                  _FlowStepChip(label: steps[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowStepChip extends StatelessWidget {
  const _FlowStepChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sp.small.w, vertical: Sp.tiny.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: colors.borderSecondary, width: 0.5),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: m11w500(context),
      ),
    );
  }
}
