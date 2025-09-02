import '../../constants/app_exports.dart';

/// A wrapper widget that provides consistent styling for settings sections
/// with different types of content (switches, inputs, platforms, etc.)
class SettingsSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final Color? iconColor;
  final double spacing;

  const SettingsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    this.iconColor,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
      child: Column(
        children: _buildChildrenWithSpacing(),
      ),
    );
  }

  List<Widget> _buildChildrenWithSpacing() {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    return spacedChildren;
  }
}
