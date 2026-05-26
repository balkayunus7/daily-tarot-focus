import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class PersonalInfoInputField extends StatelessWidget {
  const PersonalInfoInputField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      color: colors.primary.withValues(alpha: 0.05),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: m14w500(context),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Iconify(
              Mdi.account,
              color: colors.textSecondary,
              size: 18.r,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(),
          hintText: hint,
          hintStyle: m14w500(context).copyWith(color: colors.textSecondary),
          filled: false,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
