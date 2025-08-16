import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

enum CameraMode { placeholder, preview, captured }

class FacialVerificationScreen extends ConsumerStatefulWidget {
  const FacialVerificationScreen({super.key});

  @override
  ConsumerState<FacialVerificationScreen> createState() =>
      _FacialVerificationScreenState();
}

class _FacialVerificationScreenState
    extends ConsumerState<FacialVerificationScreen> {
  CameraController? _controller;
  XFile? _imageFile;
  bool _isCameraReady = false;
  bool _isPermissionGranted = false;

  CameraMode _mode = CameraMode.placeholder;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      // Pick front camera if available
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(frontCamera, ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isPermissionGranted = true;
          _isCameraReady = true;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Camera permission denied. Please enable it in settings.')),
      );
      await openAppSettings();
    }
  }

  Future<void> _takePicture() async {
    if (_controller != null && _isCameraReady) {
      try {
        final XFile file = await _controller!.takePicture();
        setState(() {
          _imageFile = file;
          _mode = CameraMode.captured;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  Widget _buildPreviewFrame({required Widget child}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rectangular container
        Container(
          width: 260,
          height: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
          ),
          clipBehavior: Clip.hardEdge,
          child: child,
        ),
        // Oval border guide
        Container(
          width: 220,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(180),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C70DF), Color(0xFFA198FF)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_mode) {
      case CameraMode.placeholder:
        content = _buildPreviewFrame(
          child: const Icon(Icons.person, color: Colors.white, size: 100),
        );
        break;
      case CameraMode.preview:
        content = _buildPreviewFrame(
          child: (_controller != null && _isCameraReady)
              ? CameraPreview(_controller!)
              : const Center(child: CircularProgressIndicator()),
        );
        break;
      case CameraMode.captured:
        content = _buildPreviewFrame(
          child: Image.file(
            File(_imageFile!.path),
            fit: BoxFit.cover,
          ),
        );
        break;
    }

    return Scaffold(
      appBar: CustomLoanAppBar(title: 'Facial Verification'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Take a selfie to verify your identity',
                style: TextStyle(fontSize: 14, color: Color(0xff4B5563)),
              ),
              const SizedBox(height: 20),
              content,
              const SizedBox(height: 30),

              // Buttons
              if (_mode == CameraMode.placeholder) ...[
                _buildGradientButton(
                  text: "Open Camera",
                  onPressed: () {
                    setState(() => _mode = CameraMode.preview);
                  },
                )
              ] else if (_mode == CameraMode.preview) ...[
                _buildGradientButton(
                  text: "Capture Selfie",
                  onPressed: _takePicture,
                )
              ] else if (_mode == CameraMode.captured) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildGradientButton(
                        text: "Retake Selfie",
                        onPressed: () {
                          setState(() {
                            _mode = CameraMode.preview;
                            _imageFile = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildGradientButton(
                        text: "Use This Photo",
                        onPressed: () {
                          context.go('/next-page'); // proceed
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
