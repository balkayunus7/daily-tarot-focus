import 'dart:async';

import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

Future<void> showTarotSheet(
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
    shape: RoundedRectangleBorder(borderRadius: Sp.large.radiusR),
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          await SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * heightFactor,
            ),
            margin: 16.padSymR(v: 32),
            child: _SheetBase(
              bodyPadding: hasBodyPadding ? Sp.screen.padAllR : EdgeInsets.zero,
              body: [
                Padding(
                  padding: hasBodyPadding ? EdgeInsets.zero : Sp.screen.padAllR,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: m16w700(context)),
                      IconButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await SystemChannels.textInput.invokeMethod('TextInput.hide');
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, color: context.colors.borderSecondary, size: 20),
                      ),
                    ],
                  ),
                ),
                if (hasBodyPadding) ...[
                  Sp.medium.heightBox,
                ] else ...[
                  const SizedBox.shrink(),
                ],
                ...body,
                Sp.small.heightBox,
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
        borderRadius: Sp.xlarge.radiusR,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: body),
    );
  }
}
