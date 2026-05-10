import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/glass_panel.dart';
import '../widgets/heritage_app_bar.dart';

const _shareBaseUrl =
    'https://1210395.github.io/jerusalem-mirror-flutter/share.html';

String _buildShareUrl(String imageUrl, String? costumeName) {
  final params = <String, String>{'img': imageUrl};
  if (costumeName != null) params['name'] = costumeName;
  final query = params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');
  return '$_shareBaseUrl?$query';
}

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
                              : () => _openShareDialog(
                                  context, imageUrl, costume),
                          icon: const Icon(Icons.qr_code_2,
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

  void _openShareDialog(BuildContext context, String imageUrl, dynamic costume) {
    final isArabic = appState.locale == 'ar';
    final costumeName = costume == null
        ? null
        : (isArabic ? costume.nameAr as String : costume.nameEn as String);
    final shareUrl = _buildShareUrl(imageUrl, costumeName);

    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: HeritageColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: HeritageColors.primaryContainer.withOpacity(0.4),
          ),
        ),
        insetPadding: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArabic ? 'تذكارك' : 'YOUR SOUVENIR',
                style: HeritageTheme.labelCaps(context, vhFactor: 0.013),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'امسح الرمز للحصول على صورتك'
                    : 'Scan to get your reflection',
                style: HeritageTheme.headlineMd(context, vhFactor: 0.022),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color:
                          HeritageColors.primaryContainer.withOpacity(0.3),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: shareUrl,
                  version: QrVersions.auto,
                  size: 240,
                  backgroundColor: Colors.white,
                  // ignore: deprecated_member_use
                  foregroundColor: Colors.black,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
              const SizedBox(height: 16),
              if (costumeName != null)
                Text(
                  costumeName,
                  style: HeritageTheme.body(context, vhFactor: 0.016)
                      .copyWith(color: HeritageColors.primary),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 4),
              Text(
                isArabic
                    ? 'يفتح صفحة تنزيل تراثية'
                    : 'Opens a heritage download page',
                style: HeritageTheme.body(context, vhFactor: 0.013),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HeritageColors.primaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isArabic ? 'إغلاق' : 'CLOSE',
                    style: HeritageTheme.labelCaps(context, vhFactor: 0.014)
                        .copyWith(
                      color: HeritageColors.onPrimary,
                      letterSpacing: 3,
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
