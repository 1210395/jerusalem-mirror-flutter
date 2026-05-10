import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data/costumes.dart';
import '../theme.dart';
import '../widgets/heritage_app_bar.dart';
import '../widgets/heritage_bottom_nav.dart';

class CostumeScreen extends StatelessWidget {
  final AppState appState;

  const CostumeScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isArabic = appState.locale == 'ar';

    return Scaffold(
      appBar: HeritageAppBar(appState: appState, showBack: true),
      bottomNavigationBar: const HeritageBottomNav(activeIndex: 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'الخزانة التاريخية' : 'HISTORICAL WARDROBE',
                    style: HeritageTheme.labelCaps(context, vhFactor: 0.012),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic
                        ? 'اختر زياً تراثياً لتجسيده'
                        : 'Choose a heritage garment to embody',
                    style: HeritageTheme.headlineMd(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: heritageCostumes.length,
                itemBuilder: (context, index) {
                  final c = heritageCostumes[index];
                  final selected = appState.selectedCostume?.id == c.id;
                  return _CostumeCard(
                    costume: c,
                    selected: selected,
                    isArabic: isArabic,
                    onTap: () {
                      appState.selectCostume(c);
                      appState.goToScreen(3);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostumeCard extends StatelessWidget {
  final Costume costume;
  final bool selected;
  final bool isArabic;
  final VoidCallback onTap;

  const _CostumeCard({
    required this.costume,
    required this.selected,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? HeritageColors.primaryContainer
                : HeritageColors.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: HeritageColors.primaryContainer.withOpacity(0.4),
                    blurRadius: 24,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(costume.colorHex).withOpacity(0.9),
                      Color(costume.colorHex).withOpacity(0.4),
                      HeritageColors.background,
                    ],
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.checkroom,
                  size: 80,
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isArabic ? costume.nameAr : costume.nameEn,
                    style: HeritageTheme.labelCaps(context, vhFactor: 0.012)
                        .copyWith(
                      color: selected
                          ? HeritageColors.primary
                          : HeritageColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: HeritageColors.accent.withOpacity(0.4),
                    border: Border.all(
                      color: HeritageColors.accentLight.withOpacity(0.6),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    costume.era,
                    style: const TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: HeritageColors.accentLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
