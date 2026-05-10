import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/heritage_app_bar.dart';

class WelcomeScreen extends StatefulWidget {
  final AppState appState;

  const WelcomeScreen({super.key, required this.appState});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.appState.locale == 'ar';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HeritageAppBar(appState: widget.appState, showHome: false),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome_hero.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => Container(
              color: HeritageColors.background,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x99131407),
                  Color(0x66131407),
                  Color(0xEE0E0F03),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () => widget.appState.goToScreen(1),
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 56,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: HeritageColors.primaryContainer,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: HeritageColors.primaryContainer.withOpacity(
                                0.3 + 0.3 * _pulse.value,
                              ),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          isArabic ? 'ابدأ الرحلة' : 'START THE JOURNEY',
                          style: const TextStyle(
                            color: HeritageColors.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 14,
                        color: HeritageColors.primary.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? 'انقر للبدء' : 'TAP TO BEGIN EXPERIENCE',
                        style: HeritageTheme.labelCaps(context, vhFactor: 0.011)
                            .copyWith(
                          color: HeritageColors.primary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
