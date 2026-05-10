import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/heritage_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isArabic = appState.locale == 'ar';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HeritageAppBar(appState: appState, showBack: true),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome_hero.jpg',
            fit: BoxFit.cover,
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
                  Color(0xCC131407),
                  Color(0x99131407),
                  Color(0xEE0E0F03),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    isArabic ? 'اختر انعكاسك' : 'Choose Your Reflection',
                    style: HeritageTheme.headlineLg(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic
                        ? 'اختر النوع لتخصيص تجربة المرآة التراثية'
                        : 'Select your gender to tailor the heritage mirror experience.',
                    style: HeritageTheme.body(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _GenderCard(
                            icon: Icons.male,
                            label: isArabic ? 'ذكر' : 'MALE',
                            onTap: () => appState.setGender('male'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _GenderCard(
                            icon: Icons.female,
                            label: isArabic ? 'أنثى' : 'FEMALE',
                            onTap: () => appState.setGender('female'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_GenderCard> createState() => _GenderCardState();
}

class _GenderCardState extends State<_GenderCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapCancel: () => setState(() => _hovered = false),
      onTapUp: (_) => setState(() => _hovered = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? HeritageColors.primaryContainer
                : HeritageColors.primaryContainer.withOpacity(0.2),
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: HeritageColors.primaryContainer.withOpacity(0.3),
                    blurRadius: 24,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HeritageColors.primaryContainer.withOpacity(0.1),
                border: Border.all(
                  color: HeritageColors.primaryContainer.withOpacity(0.3),
                ),
              ),
              child: Icon(
                widget.icon,
                size: 64,
                color: HeritageColors.primaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.label,
              style: HeritageTheme.labelCaps(context, vhFactor: 0.018)
                  .copyWith(letterSpacing: 4),
            ),
          ],
        ),
      ),
    );
  }
}
