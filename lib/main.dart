import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/costume_screen.dart';
import 'screens/garment_detail_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/processing_screen.dart';
import 'screens/result_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const JerusalemMirrorApp());
}

class JerusalemMirrorApp extends StatefulWidget {
  const JerusalemMirrorApp({super.key});

  @override
  State<JerusalemMirrorApp> createState() => _JerusalemMirrorAppState();
}

class _JerusalemMirrorAppState extends State<JerusalemMirrorApp> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    _appState.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _appState.locale == 'ar';

    return MaterialApp(
      title: 'Jerusalem Heritage AI Mirror',
      debugShowCheckedModeBanner: false,
      theme: HeritageTheme.dark(_appState.locale),
      locale: Locale(isArabic ? 'ar' : 'en'),
      builder: (context, child) {
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_appState.currentScreen) {
      case 0:
        return WelcomeScreen(appState: _appState);
      case 1:
        return ProfileScreen(appState: _appState);
      case 2:
        return CostumeScreen(appState: _appState);
      case 3:
        return GarmentDetailScreen(appState: _appState);
      case 4:
        return CaptureScreen(appState: _appState);
      case 5:
        return ProcessingScreen(appState: _appState);
      case 6:
        return ResultScreen(appState: _appState);
      default:
        return WelcomeScreen(appState: _appState);
    }
  }
}
