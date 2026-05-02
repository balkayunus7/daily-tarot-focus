part of '../pages/tarot_reading_detail_page.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({super.key});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final scope = DetailPageScope.of(context).state;
    final colors = context.colors;

    return SingleChildScrollView(
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
                TextField(
                  controller: scope.notesController,
                  minLines: 8,
                  maxLines: 12,
                  maxLength: 360,
                  textAlignVertical: TextAlignVertical.top,
                  style: m14w400(context).copyWith(
                    color: colors.textPrimary.withValues(alpha: 0.85),
                    height: 1.7,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.tarot_reading_notes_placeholder.tr(),
                    hintStyle: m13w400(context).copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.4),
                    ),
                    counterStyle: m11w400(context).copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: scope.isDirty,
            builder: (context, dirty, _) {
              if (!dirty) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(top: Sp.medium.h),
                child: BlocBuilder<TarotBloc, TarotState>(
                  buildWhen: (prev, curr) => prev.isUpdatingNote != curr.isUpdatingNote,
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: state.isUpdatingNote ? null : scope.onSaveNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          disabledBackgroundColor: colors.primary.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: Sp.medium.radiusR,
                          ),
                        ),
                        child: state.isUpdatingNote
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.textOnPrimary,
                                ),
                              )
                            : Text(
                                LocaleKeys.tarot_reading_save.tr(),
                                style: m14w600(context).copyWith(color: colors.textOnPrimary),
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
