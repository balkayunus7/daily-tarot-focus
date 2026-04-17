import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/glass_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reader_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class ReaderCard extends StatelessWidget {
  const ReaderCard({
    required this.reader,
    required this.onTap,
    super.key,
  });

  final TarotReaderModel reader;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: GlassContainer(
        padding: Sp.small.padSymR(h: Sp.medium, v: Sp.small),
        borderRadius: Sp.medium,
        glassColor: colors.primary.withValues(alpha: 0.05),
        borderColor: colors.primary.withValues(alpha: 0.08),
        child: Row(
          children: [
            _ReaderAvatar(icon: reader.icon),
            Sp.medium.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StarRow(rating: reader.rating, reviewCount: reader.reviewCount),
                  2.heightBox,
                  Text(reader.name, style: m15w600(context)),
                  2.heightBox,
                  Text(
                    reader.bio,
                    style: m12w500(context).copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.55),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Sp.tiny.heightBox,
                  _TagRow(tags: reader.tags),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderAvatar extends StatelessWidget {
  const _ReaderAvatar({required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52.w,
          height: 52.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.gradientStart, colors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: Sp.small.radiusR,
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: (Sp.small - 2).radiusR,
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
        ),
      ],
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fullStars = rating.floor();
    const totalStars = 5;

    return Row(
      children: [
        ...List.generate(totalStars, (i) {
          return Icon(
            i < fullStars ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 12.r,
            color: const Color(0xFFF59E0B),
          );
        }),
        4.widthBox,
        Text(
          '($reviewCount)',
          style: m10w500(context).copyWith(
            color: colors.textSecondary.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tags});
  final KtList<TarotReaderTag> tags;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: 5,
      runSpacing: 4,
      children:
          tags
              .map<Widget>(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.18),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(tag.emoji, style: const TextStyle(fontSize: 10)),
                      4.widthBox,
                      Text(
                        tag.label,
                        style: m10w500(context).copyWith(
                          color: colors.primary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .asList(),
    );
  }
}
