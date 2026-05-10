import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

class LanguageToggle extends StatelessWidget {
  final AppState appState;

  const LanguageToggle({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isArabic = appState.locale == 'ar';
    return GestureDetector(
      onTap: () => appState.setLocale(isArabic ? 'en' : 'ar'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: HeritageColors.primaryContainer.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 16, color: HeritageColors.primary),
            const SizedBox(width: 6),
            Text(
              isArabic ? 'EN' : 'العربية',
              style: HeritageTheme.labelCaps(context, vhFactor: 0.013),
            ),
          ],
        ),
      ),
    );
  }
}
