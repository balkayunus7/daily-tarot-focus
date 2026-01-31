part of '../pages/tarot_reveal_detail_page.dart';

class RevealDetailSection extends StatelessWidget {
  const RevealDetailSection({
    required this.title,
    required this.descriptions,
    required this.icon,
    required this.iconColor,
    super.key,
  });
  final String title;
  final List<String> descriptions;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: m18w600(context)),
        Spacing.mediumH,
        ...descriptions.map(
          (description) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 12),
                  child: Icon(
                    icon,
                    size: SpacingConsts.large,
                    color: iconColor
                  ),
                ),
                Expanded(
                  child: Text(
                    description,
                    style: m14w500(context).copyWith(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
