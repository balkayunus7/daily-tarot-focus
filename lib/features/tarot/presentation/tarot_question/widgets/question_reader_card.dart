import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/glass_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
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
            _ReaderAvatar(image: reader.imageUrl),
            Sp.medium.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Sp.tiny.heightBox,
                  Text(reader.name, style: m15w600(context)),
                  Sp.tiny.heightBox,
                  Text(
                    reader.bio,
                    style: m10w400(context).copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Sp.small.heightBox,
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
  const _ReaderAvatar({required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84.w,
      height: 84.h,
      child: Container(
        decoration: BoxDecoration(borderRadius: Sp.xxxlarge.radiusR),
        clipBehavior: Clip.antiAlias,
        child: CustomCacheNetworkImage(imageUrl: image, fit: BoxFit.cover),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tags});
  final KtList<ReaderTagModel> tags;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.border, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tag.emoji, style: const TextStyle(fontSize: 11)),
                  Sp.tiny.widthBox,
                  Text(
                    tag.label,
                    style: m10w500(context).copyWith(color: colors.textPrimary),
                  ),
                ],
              ),
            );
          }).asList(),
    );
  }
}
