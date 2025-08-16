import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_actions_button.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:pcsloan/common/widgets/gradient_action_button.dart';
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

  // Future<void> _checkPermission() async {
  //   final status = await Permission.camera.request();
  //   if (status.isGranted) {
  //     final cameras = await availableCameras();
  //     // Pick front camera if available
  //     final frontCamera = cameras.firstWhere(
  //       (cam) => cam.lensDirection == CameraLensDirection.front,
  //       orElse: () => cameras.first,
  //     );

  //     _controller = CameraController(frontCamera, ResolutionPreset.medium);
  //     await _controller!.initialize();
  //     if (mounted) {
  //       setState(() {
  //         _isPermissionGranted = true;
  //         _isCameraReady = true;
  //       });
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Camera permission denied. Please enable it in settings.',
  //         ),
  //       ),
  //     );
  //     await openAppSettings();
  //   }
  // }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();

    if (!mounted) return;

    if (status.isGranted) {
      try {
        final cameras = await availableCameras();

        // Try to get front camera
        CameraDescription camera;
        try {
          camera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
          );
        } catch (_) {
          camera = cameras.first; // fallback to first camera
        }

        _controller = CameraController(
          camera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _controller!.initialize();

        if (mounted) {
          setState(() {
            _isPermissionGranted = true;
            _isCameraReady = true;
          });
        }
      } catch (e) {
        debugPrint("Camera init failed: $e");
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Camera not available: $e")));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Camera permission denied. Please enable it in settings.',
          ),
        ),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
      }
    }
  }

  Widget _buildPreviewFrame({required Widget child}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rectangular container
        Container(
          width: 290,
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

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
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
          child: const Icon(Icons.person, color: Colors.white, size: 80),
        );
        break;
      case CameraMode.preview:
        content = _buildPreviewFrame(
          child:
              (_controller != null &&
                      _controller!.value.isInitialized &&
                      _isCameraReady)
                  ? CameraPreview(_controller!)
                  : const Center(child: CircularProgressIndicator()),
        );
        break;
      case CameraMode.captured:
        content = _buildPreviewFrame(
          child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
        );
        break;
    }

    return Scaffold(
      appBar: CustomLoanAppBar(title: 'Facial Verification'),
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffA198FF).withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.camera_alt,
                            color: Color(0xff7C70DF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'Take a selfie to verify your identity',
                  style: TextStyle(fontSize: 14, color: Color(0xff4B5563)),
                ),
                const SizedBox(height: 20),
                content,
                const SizedBox(height: 20),

                // Buttons
                if (_mode == CameraMode.placeholder) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() => _mode = CameraMode.preview);
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFFFFF),
                        border: Border.all(
                          color: Color(0xFF7C70DF), // Darker purple border
                          width: 7,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Color(0xff7C70DF),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ] else if (_mode == CameraMode.preview) ...[
                  _buildGradientButton(
                    text: "Capture Selfie",
                    onPressed: _takePicture,
                  ),
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
                      // Expanded(
                      //   child: _buildGradientButton(
                      //     text: "Use This Photo",
                      //     onPressed: () {
                      //       context.go('/next-page'); // proceed
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Capture Face',
                    style: TextStyle(color: Color(0xff4B5563)),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xffF9FAFB),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xff7C70DF),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Tips for best results',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          _buildTip('Ensure good lighting on your face'),
                          _buildTip('Face the camera directly'),
                          _buildTip('Remove glasses or hats if possible'),
                          _buildTip('Keep your face within the circle'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xffF5F5FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.question_mark_outlined,
                        size: 20,
                        color: Color(0xffA198FF),
                      ),
                      SizedBox(width: 3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your photo is processed securely and used only for',
                              style: TextStyle(fontSize: 11.5),
                            ),
                            Text(
                              'verification. It will be deleted after the process.',
                              style: TextStyle(fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Divider(thickness: 2, color: Color(0xFFE5E7EB)),
                SizedBox(height: 20),

                GradientActionButton(
                  text: 'Proceed',
                  onPressed: () {},
                  size: 18,
                ),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      return null;
                    },
                    child: Text(
                      "Having trouble? Get help",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffA198FF),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8.0, color: Color(0xff7C70DF)),
          SizedBox(width: 8.0),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16.0))),
        ],
      ),
    );
  }
}
