import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/glass_panel.dart';
import '../widgets/heritage_app_bar.dart';

class CaptureScreen extends StatefulWidget {
  final AppState appState;

  const CaptureScreen({super.key, required this.appState});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CameraController? _controller;
  bool _initializing = true;
  String? _initError;
  int _countdown = 0;
  Timer? _countdownTimer;
  String? _capturedPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        setState(() {
          _initializing = false;
          _initError = 'No cameras available';
        });
        return;
      }
      final front = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cams.first,
      );
      final controller =
          CameraController(front, ResolutionPreset.high, enableAudio: false);
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } catch (e) {
      setState(() {
        _initializing = false;
        _initError = e.toString();
      });
    }
  }

  void _startCountdown() {
    setState(() => _countdown = 3);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_countdown <= 1) {
        t.cancel();
        _capture();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _capture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final pic = await _controller!.takePicture();
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final dest = '${dir.path}/heritage_capture_$ts.jpg';
    await File(pic.path).copy(dest);
    if (!mounted) return;
    setState(() {
      _countdown = 0;
      _capturedPath = dest;
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.appState.locale == 'ar';

    return Scaffold(
      appBar: HeritageAppBar(appState: widget.appState, showBack: true),
      body: Stack(
        children: [
          // Camera or placeholder
          Positioned.fill(child: _buildCameraLayer()),
          // Body silhouette guide
          if (_capturedPath == null)
            Center(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  margin: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: HeritageColors.primaryContainer.withOpacity(0.4),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: Stack(
                    children: [
                      ..._buildCornerAccents(),
                    ],
                  ),
                ),
              ),
            ),
          // Countdown overlay
          if (_countdown > 0)
            Center(
              child: Text(
                '$_countdown',
                style: HeritageTheme.displayHero(context, vhFactor: 0.18),
              ),
            ),
          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: _buildBottomControls(context, isArabic),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraLayer() {
    if (_initializing) {
      return const Center(
        child: CircularProgressIndicator(color: HeritageColors.primary),
      );
    }
    if (_initError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off,
                color: HeritageColors.primary, size: 48),
            const SizedBox(height: 16),
            Text(
              _initError!,
              style: const TextStyle(color: HeritageColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() => _initializing = true);
                _initCamera();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_capturedPath != null) {
      return Image.file(File(_capturedPath!), fit: BoxFit.cover);
    }
    return CameraPreview(_controller!);
  }

  List<Widget> _buildCornerAccents() {
    const corner = SizedBox(
      width: 32,
      height: 32,
    );
    final color = HeritageColors.primaryContainer;
    Widget accent(Alignment alignment) {
      final isTop = alignment.y < 0;
      final isLeft = alignment.x < 0;
      return Align(
        alignment: alignment,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border(
              top: isTop ? BorderSide(color: color, width: 2) : BorderSide.none,
              bottom:
                  !isTop ? BorderSide(color: color, width: 2) : BorderSide.none,
              left:
                  isLeft ? BorderSide(color: color, width: 2) : BorderSide.none,
              right: !isLeft
                  ? BorderSide(color: color, width: 2)
                  : BorderSide.none,
            ),
          ),
          child: corner,
        ),
      );
    }

    return [
      accent(Alignment.topLeft),
      accent(Alignment.topRight),
      accent(Alignment.bottomLeft),
      accent(Alignment.bottomRight),
    ];
  }

  Widget _buildBottomControls(BuildContext context, bool isArabic) {
    if (_capturedPath != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ghostButton(
              isArabic ? 'إعادة' : 'RETAKE',
              Icons.refresh,
              () => setState(() => _capturedPath = null),
            ),
            _solidButton(
              isArabic ? 'متابعة' : 'CONTINUE',
              Icons.check_circle,
              () {
                widget.appState.capturedPhotoPath = _capturedPath;
                widget.appState.goToScreen(5);
              },
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            radius: 40,
            child: Text(
              isArabic
                  ? 'حاذِ جسمك مع الإطار الذهبي'
                  : 'Full body aligned with guide',
              style: HeritageTheme.headlineMd(context, vhFactor: 0.02),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _solidButton(
            isArabic ? 'ابدأ' : 'START',
            Icons.play_arrow,
            _countdown > 0 ? null : _startCountdown,
            big: true,
          ),
        ],
      ),
    );
  }

  Widget _ghostButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: HeritageColors.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: HeritageColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: HeritageTheme.labelCaps(context, vhFactor: 0.014).copyWith(
                color: HeritageColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _solidButton(
    String label,
    IconData icon,
    VoidCallback? onTap, {
    bool big = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: big ? 48 : 24,
          vertical: big ? 18 : 14,
        ),
        decoration: BoxDecoration(
          color: onTap == null
              ? HeritageColors.primaryContainer.withOpacity(0.3)
              : HeritageColors.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          boxShadow: onTap == null
              ? null
              : [
                  BoxShadow(
                    color: HeritageColors.primaryContainer.withOpacity(0.4),
                    blurRadius: 24,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: HeritageColors.onPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: HeritageTheme.labelCaps(context, vhFactor: big ? 0.018 : 0.014)
                  .copyWith(
                color: HeritageColors.onPrimary,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
