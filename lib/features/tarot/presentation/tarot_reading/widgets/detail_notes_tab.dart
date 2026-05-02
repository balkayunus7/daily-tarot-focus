part of '../pages/tarot_reading_detail_page.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({required this.note, super.key});
  final String? note;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasNote = note != null && note!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.large.h, Sp.screen.w, Sp.xxxlarge.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Sp.large.w),
            decoration: BoxDecoration(
              color: colors.textSecondary.withValues(alpha: 0.06),
              borderRadius: Sp.large.radiusR,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.tarot_reading_notes_title.tr(), style: m14w700(context)),
                SizedBox(height: Sp.small.h),
                Text(
                  hasNote ? note! : LocaleKeys.tarot_reading_no_notes.tr(),
                  style: m14w400(context).copyWith(
                    color:
                        hasNote
                            ? colors.textPrimary.withValues(alpha: 0.85)
                            : colors.textSecondary.withValues(alpha: 0.4),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
