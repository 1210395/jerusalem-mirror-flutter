import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;
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
    final isFront =
        _controller!.description.lensDirection == CameraLensDirection.front;

    // Front camera: live preview is mirrored, but the saved JPEG is the
    // raw sensor data (not mirrored). Flip horizontally so the captured
    // photo matches what the user saw in the preview.
    Uint8List bytes = await File(pic.path).readAsBytes();
    if (isFront) {
      final decoded = img_lib.decodeImage(bytes);
      if (decoded != null) {
        final flipped = img_lib.flipHorizontal(decoded);
        bytes = Uint8List.fromList(img_lib.encodeJpg(flipped, quality: 92));
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final dest = '${dir.path}/heritage_capture_$ts.jpg';
    await File(dest).writeAsBytes(bytes);

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
      backgroundColor: HeritageColors.background,
      appBar: HeritageAppBar(appState: widget.appState, showBack: true),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'حاذِ نفسك مع الإطار الذهبي'
                  : 'Align with the golden frame',
              style: HeritageTheme.labelCaps(context, vhFactor: 0.013),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Constrained camera preview card
            Expanded(
              flex: 5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: HeritageColors.primaryContainer.withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                HeritageColors.primaryContainer.withOpacity(0.2),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildCameraLayer(),
                            // Body silhouette guide (rounded oval) inside preview
                            if (_capturedPath == null)
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: HeritageColors.primaryContainer
                                          .withOpacity(0.5),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: Stack(
                                    children: _buildCornerAccents(),
                                  ),
                                ),
                              ),
                            // Countdown overlay
                            if (_countdown > 0)
                              Container(
                                color: Colors.black.withOpacity(0.3),
                                child: Center(
                                  child: Text(
                                    '$_countdown',
                                    style: HeritageTheme.displayHero(context,
                                        vhFactor: 0.16),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom controls
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildBottomControls(context, isArabic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraLayer() {
    if (_initializing) {
      return Container(
        color: HeritageColors.surface,
        child: const Center(
          child: CircularProgressIndicator(color: HeritageColors.primary),
        ),
      );
    }
    if (_initError != null) {
      return Container(
        color: HeritageColors.surface,
        padding: const EdgeInsets.all(24),
        child: Center(
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
        ),
      );
    }
    if (_capturedPath != null) {
      return Image.file(File(_capturedPath!), fit: BoxFit.cover);
    }
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1 / _controller!.value.aspectRatio,
        child: CameraPreview(_controller!),
      ),
    );
  }

  List<Widget> _buildCornerAccents() {
    final color = HeritageColors.primaryContainer;
    Widget accent(Alignment alignment) {
      final isTop = alignment.y < 0;
      final isLeft = alignment.x < 0;
      return Align(
        alignment: alignment,
        child: Container(
          width: 24,
          height: 24,
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
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
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          radius: 30,
          child: Text(
            isArabic
                ? 'حاذِ جسمك مع الإطار الذهبي'
                : 'Full body aligned with guide',
            style: HeritageTheme.body(context, vhFactor: 0.016),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        _solidButton(
          isArabic ? 'ابدأ' : 'START',
          Icons.play_arrow,
          _countdown > 0 ? null : _startCountdown,
          big: true,
        ),
      ],
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
            Icon(icon, color: HeritageColors.onSurfaceVariant, size: 20),
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
          vertical: big ? 16 : 14,
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
            Icon(icon, color: HeritageColors.onPrimary, size: big ? 24 : 20),
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
