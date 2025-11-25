import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class CustomSectionHeader extends StatelessWidget {
  const CustomSectionHeader({
    super.key,
    required this.title,
    this.value,
    this.onChanged,
    this.showToggle = false,
  });
  final String title;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final bool showToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: n16w600(context).copyWith(color: context.colors.textPrimary),
          ),
        ),
        if (value != null && onChanged != null && showToggle) ...[
          FlutterSwitch(
            width: 42,
            height: 24,
            value: value!,
            onToggle: (value) => onChanged!(value),
            toggleSize: 21,
            padding: 1.5,
            borderRadius: 100,
            activeColor: context.colors.primary,
            inactiveColor: Colors.white10,
          ),
          Spacing.xsmallW,
        ],
        Icon(Icons.chevron_right, size: 28),
      ],
    );
  }
}
