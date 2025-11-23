import 'package:daily_tarot_focus/presentation/core/constants/lyrics_app_sizes.dart';
import 'package:daily_tarot_focus/presentation/core/helper/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

Future<void> showSheetBase(
  BuildContext context, {
  required double heightFactor,
  required List<Widget> body,
  required String title,
  bool hasBodyPadding = true,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: Spacing.largeBorderRadius),
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * heightFactor,
            ),
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: _SheetBase(
              bodyPadding:
                  hasBodyPadding ? Spacing.defaultPadding : EdgeInsets.zero,
              body: [
                Padding(
                  padding:
                      hasBodyPadding ? EdgeInsets.zero : Spacing.defaultPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: n16w700(context)),
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: context.colors.borderSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                hasBodyPadding ? Spacing.mediumH : SizedBox.shrink(),
                ...body,
                Spacing.smallH,
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _SheetBase extends StatelessWidget {
  const _SheetBase({required this.body, required this.bodyPadding});
  final List<Widget> body;
  final EdgeInsets bodyPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: bodyPadding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: Spacing.xlargeBorderRadius,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: body),
    );
  }
}
