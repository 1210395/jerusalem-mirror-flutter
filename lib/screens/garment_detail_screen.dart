import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/glass_panel.dart';
import '../widgets/heritage_app_bar.dart';

class GarmentDetailScreen extends StatelessWidget {
  final AppState appState;

  const GarmentDetailScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isArabic = appState.locale == 'ar';
    final costume = appState.selectedCostume;
    if (costume == null) {
      // Defensive: bounce back to costume select.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => appState.goToScreen(2),
      );
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: HeritageAppBar(appState: appState, showBack: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero garment block
            Container(
              height: MediaQuery.of(context).size.height * 0.42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(costume.colorHex),
                    Color(costume.colorHex).withOpacity(0.3),
                    HeritageColors.background,
                  ],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/costumes/${costume.id}.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.checkroom,
                        size: 180,
                        color:
                            HeritageColors.primaryContainer.withOpacity(0.4),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(costume.colorHex).withOpacity(0.3),
                          Colors.transparent,
                          HeritageColors.background,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: HeritageColors.accent.withOpacity(0.4),
                        border: Border.all(color: HeritageColors.accentLight),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        costume.era.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: HeritageColors.accentLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Educational glass panel
            Container(
              transform: Matrix4.translationValues(0, -24, 0),
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xCC131407),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: Color(0x4DD4AF37)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? costume.nameAr : costume.nameEn,
                    style: HeritageTheme.headlineLg(context),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: HeritageColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? costume.regionAr : costume.regionEn,
                        style: HeritageTheme.body(context, vhFactor: 0.016),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isArabic ? costume.descriptionAr : costume.descriptionEn,
                    style: HeritageTheme.body(context),
                  ),
                  const SizedBox(height: 24),
                  _DetailRow(
                    label: isArabic ? 'الأهمية' : 'SIGNIFICANCE',
                    value: isArabic
                        ? costume.significanceAr
                        : costume.significanceEn,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    label: isArabic ? 'التقنية' : 'TECHNIQUE',
                    value: isArabic
                        ? costume.techniqueAr
                        : costume.techniqueEn,
                  ),
                  const SizedBox(height: 16),
                  GlassPanel(
                    borderColor: HeritageColors.accent.withOpacity(0.5),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'حقيقة تراثية' : 'HERITAGE FACT',
                          style: HeritageTheme.labelCaps(context,
                                  vhFactor: 0.012)
                              .copyWith(color: HeritageColors.accentLight),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isArabic
                              ? costume.heritageFactAr
                              : costume.heritageFactEn,
                          style: HeritageTheme.body(context).copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => appState.goToScreen(4),
                      icon: const Icon(Icons.camera_enhance,
                          color: HeritageColors.onPrimary),
                      label: Text(
                        isArabic
                            ? 'ابدأ جلسة التصوير'
                            : 'START PHOTO SESSION',
                        style: HeritageTheme.labelCaps(context,
                                vhFactor: 0.014)
                            .copyWith(
                          color: HeritageColors.onPrimary,
                          letterSpacing: 2.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HeritageColors.primaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: HeritageColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: HeritageTheme.labelCaps(context, vhFactor: 0.011)
                .copyWith(color: HeritageColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: HeritageTheme.body(context, vhFactor: 0.016)
                .copyWith(color: HeritageColors.onSurface),
          ),
        ],
      ),
    );
  }
}
