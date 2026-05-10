import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
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
          Positioned.fill(
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(context),
                  )
                : _placeholder(context),
          ),
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
                          isArabic
                              ? 'انعكاسك التراثي'
                              : 'YOUR HERITAGE REFLECTION',
                          style: HeritageTheme.labelCaps(context,
                              vhFactor: 0.012),
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
                            style:
                                HeritageTheme.body(context, vhFactor: 0.014),
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
                          width: 96,
                          height: 96,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: imageUrl != null
                              ? QrImageView(
                                  data: imageUrl,
                                  version: QrVersions.auto,
                                  backgroundColor: Colors.white,
                                  // ignore: deprecated_member_use
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.zero,
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.qr_code_2,
                                    size: 64,
                                    color: Colors.black26,
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
                                imageUrl == null
                                    ? (isArabic
                                        ? 'قيد الإنشاء…'
                                        : 'Generating…')
                                    : (isArabic
                                        ? 'امسح الرمز لمشاهدة صورتك'
                                        : 'Scan to view your reflection'),
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
                          onPressed: imageUrl == null
                              ? null
                              : () => _share(context, imageUrl, costume?.nameEn),
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
                            disabledBackgroundColor:
                                HeritageColors.primaryContainer.withOpacity(0.3),
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

  Future<void> _share(
      BuildContext context, String imageUrl, String? costumeName) async {
    final isArabic = appState.locale == 'ar';
    final text = isArabic
        ? 'انعكاسي التراثي من مرآة القدس${costumeName != null ? ' - $costumeName' : ''}\n$imageUrl'
        : 'My Jerusalem Heritage reflection${costumeName != null ? ' - $costumeName' : ''}\n$imageUrl';
    await Share.share(text);
  }

  Widget _placeholder(BuildContext context) {
    final c = appState.selectedCostume;
    if (c != null) {
      return Image.asset(
        'assets/images/costumes/${c.id}.jpg',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _solidFallback(c),
      );
    }
    return _solidFallback(c);
  }

  Widget _solidFallback(dynamic c) {
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
  }
}
