import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import 'language_toggle.dart';

class HeritageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppState appState;
  final String? subtitle;
  final bool showBack;
  final bool showHome;

  const HeritageAppBar({
    super.key,
    required this.appState,
    this.subtitle,
    this.showBack = false,
    this.showHome = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isArabic = appState.locale == 'ar';
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: HeritageColors.primaryContainer.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: HeritageColors.primary),
              onPressed: () {
                if (appState.currentScreen > 0) {
                  appState.goToScreen(appState.currentScreen - 1);
                }
              },
            ),
          const Icon(Icons.account_balance, color: HeritageColors.primaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              subtitle ??
                  (isArabic ? 'مرآة تراث القدس' : 'JERUSALEM HERITAGE AI'),
              style: HeritageTheme.labelCaps(context, vhFactor: 0.016),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          LanguageToggle(appState: appState),
          if (showHome) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.home_filled,
                  color: HeritageColors.primaryContainer),
              tooltip: isArabic ? 'الرئيسية' : 'Home',
              onPressed: () => appState.reset(),
            ),
          ],
        ],
      ),
    );
  }
}
