part of '../pages/zodiac_compatibility_result_page.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({required this.request, required this.response, super.key});
  final GenerateCompatibilityRequestModel request;
  final GenerateCompatibilityResponse response;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = ZodiacCompatibilityPageScope.of(context).state;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SignAvatar(sign: request.mySign),
            Padding(
              padding: Sp.large.padHR,
              child: Icon(
                Icons.favorite_rounded,
                color: colors.error,
                size: 28.sp,
              ),
            ),
            _SignAvatar(sign: request.partnerSign),
          ],
        ),
        Sp.large.heightBox,
        Text(
          scope.compatibilityTitleForScore(context, response.overallScore),
          style: m18w700(context).copyWith(
            color: scope.compatibilityTitleColor(
              context,
              response.overallScore,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        Sp.xsmall.heightBox,
        Text(
          scope.compatibilityDescriptionForScore(
            context,
            response.overallScore,
          ),
          style: m13w400(
            context,
          ).copyWith(color: colors.textSecondary, height: 1.45),
          textAlign: TextAlign.center,
        ),
        Sp.medium.heightBox,
        Container(height: 1, color: colors.border),
        Sp.medium.heightBox,
        _OverallBar(score: response.overallScore),
      ],
    );
  }
}

class _SignAvatar extends StatelessWidget {
  const _SignAvatar({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FancyContainer(
      borderRadius: Sp.huge,
      width: 72.w,
      height: 72.h,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.gradientStart, colors.gradientEnd],
      ),
      child: Center(
        child: SvgPicture.asset(
          sign.svgPath,
          width: 34.w,
          height: 34.w,
          colorFilter: ColorFilter.mode(colors.textOnPrimary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
