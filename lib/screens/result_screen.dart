import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/glass_panel.dart';
import '../widgets/heritage_app_bar.dart';

class ResultScreen extends StatelessWidget {
  final AppState appState;

  const ResultScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isArabic = appState.locale == 'ar';
    final costume = appState.selectedCostume;
    final imageUrl = appState.generatedImageUrl;

    return Scaffold(
      appBar: HeritageAppBar(
        appState: appState,
        subtitle: isArabic ? 'الكشف النهائي' : 'STEP 10: FINAL REVEAL',
      ),
      body: Stack(
        children: [
          // Hero image background
          Positioned.fill(
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(context),
                  )
                : _placeholder(context),
          ),
          // Vignette
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66131407),
                    Colors.transparent,
                    Color(0xCC0E0F03),
                  ],
                ),
              ),
            ),
          ),
          // Overlay content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassPanel(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'انعكاسك التراثي' : 'YOUR HERITAGE REFLECTION',
                          style: HeritageTheme.labelCaps(context, vhFactor: 0.012),
                        ),
                        const SizedBox(height: 8),
                        if (costume != null)
                          Text(
                            isArabic ? costume.nameAr : costume.nameEn,
                            style: HeritageTheme.headlineLg(context),
                          ),
                        if (costume != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${costume.era}  ·  ${isArabic ? costume.regionAr : costume.regionEn}',
                            style: HeritageTheme.body(context, vhFactor: 0.014),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  GlassPanel(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.qr_code_2,
                              size: 64,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'تذكار' : 'SOUVENIR',
                                style: HeritageTheme.labelCaps(context,
                                    vhFactor: 0.012),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isArabic
                                    ? 'امسح الرمز لتحميل تذكارك'
                                    : 'Scan to download your souvenir',
                                style: HeritageTheme.headlineMd(context,
                                    vhFactor: 0.018),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => appState.reset(),
                          icon: const Icon(Icons.replay,
                              color: HeritageColors.primary),
                          label: Text(
                            isArabic ? 'ابدأ من جديد' : 'START OVER',
                            style: HeritageTheme.labelCaps(context,
                                    vhFactor: 0.013)
                                .copyWith(color: HeritageColors.primary),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                                color: HeritageColors.primaryContainer),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic
                                      ? 'وظيفة المشاركة قيد الإعداد'
                                      : 'Share coming soon',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share,
                              color: HeritageColors.onPrimary),
                          label: Text(
                            isArabic ? 'شارك' : 'SHARE',
                            style: HeritageTheme.labelCaps(context,
                                    vhFactor: 0.013)
                                .copyWith(color: HeritageColors.onPrimary),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HeritageColors.primaryContainer,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Image.asset(
      'assets/images/souvenir_bg.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        final c = appState.selectedCostume;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(c?.colorHex ?? 0xFF2A2B1B),
                HeritageColors.background,
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.account_balance,
              size: 200,
              color: Color(0x33D4AF37),
            ),
          ),
        );
      },
    );
  }
}
