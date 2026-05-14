import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: m14w500(context),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: m14w500(context).copyWith(color: colors.textSecondary),
        filled: true,
        fillColor: colors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: Sp.medium.radiusR,
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Sp.medium.radiusR,
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Sp.medium.radiusR,
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
