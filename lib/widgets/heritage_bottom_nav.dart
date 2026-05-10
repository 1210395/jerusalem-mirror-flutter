import 'package:flutter/material.dart';
import '../theme.dart';

class HeritageBottomNav extends StatelessWidget {
  final int activeIndex;

  const HeritageBottomNav({super.key, this.activeIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: HeritageColors.primaryContainer.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home, label: 'Home', active: activeIndex == 0),
          _NavItem(
            icon: Icons.face_retouching_natural,
            label: 'Mirror',
            active: activeIndex == 1,
          ),
          _NavItem(icon: Icons.checkroom, label: 'Gallery', active: activeIndex == 2),
          _NavItem(icon: Icons.menu_book, label: 'Trivia', active: activeIndex == 3),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? HeritageColors.primaryContainer
        : Colors.grey.withOpacity(0.7);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: active ? 28 : 24),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
