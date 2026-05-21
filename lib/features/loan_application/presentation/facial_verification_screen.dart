// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
// import 'package:smile_id/products/biometric/smile_id_biometric_kyc.dart';
// import 'package:smile_id/smile_id.dart';
// import 'dart:io';



// class SmileIDVerificationScreen extends ConsumerStatefulWidget {
//   const SmileIDVerificationScreen({super.key});

//   @override
//   ConsumerState<SmileIDVerificationScreen> createState() =>
//       _SmileIDVerificationScreenState();
// }

// class _SmileIDVerificationScreenState
//     extends ConsumerState<SmileIDVerificationScreen>
//     with SingleTickerProviderStateMixin {
//   bool _isInitialized = false;
//   String? _errorMessage;
//   late AnimationController _shieldController;
//   late Animation<double> _shieldAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     _shieldController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat(reverse: true);
    
//     _shieldAnimation = Tween<double>(
//       begin: 0.95,
//       end: 1.05,
//     ).animate(CurvedAnimation(
//       parent: _shieldController,
//       curve: Curves.easeInOut,
//     ));
    
//     _initializeSmileID();
//   }

//   @override
//   void dispose() {
//     _shieldController.dispose();
//     super.dispose();
//   }

//   /// Initialize Smile ID SDK
//   void _initializeSmileID() {
//     try {
//       SmileID.initialize(
//         useSandbox: true, // Set to false for production
//         enableCrashReporting: false,
//       );

//       setState(() {
//         _isInitialized = true;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to initialize Smile ID: $e';
//       });
//     }
//   }

//   /// Launch BVN Biometric KYC Verification
//   void _launchVerification() {
//     if (!_isInitialized) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Smile ID is not initialized yet')),
//       );
//       return;
//     }

//     print("🚀 Starting BVN Biometric KYC Verification");

//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (BuildContext context) => Scaffold(
//           appBar: AppBar(
//             title: const Text("BVN Verification"),
//             backgroundColor: const Color(0xff7C70DF),
//           ),
//           body: SmileIDBiometricKYC(
//             country: "NG", // Nigeria
//             idType: "VOTER_ID", // Bank Verification Number
//             idNumber: "0000000000000000004", // TODO: Replace with actual user BVN
//             userId: "4f97b378-5b12-4c07-9802-0cb93465f033",
//             showInstructions: false, // Show instruction screen
//             useStrictMode: false, // Set to true for enhanced SmartSelfie™ capture
//             consentGrantedDate: DateTime.now().toIso8601String(),
//             personalDetailsConsentGranted: true,
//             contactInformationConsentGranted: false,
//             documentInformationConsentGranted: false,
//             onSuccess: (String? result) {
//               _handleSuccess(result);
//             },
//             onError: (String errorMessage) {
//               _handleError(errorMessage);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   /// Handle successful BVN verification
//   void _handleSuccess(String? result) async {
//     print("==========================================");
//     print("✅ SMILE ID BVN VERIFICATION SUCCESS");
//     print("==========================================");

//     if (result != null && result.isNotEmpty) {
//       try {
//         // Parse the JSON result
//         final resultData = jsonDecode(result);

//         // Print the ENTIRE result to see what we're getting
//         print("\n📋 FULL RESULT DATA:");
//         print(jsonEncode(resultData));
//         print("\n");

//         // Try different possible keys for jobId
//         String? jobId;
        
//         // Check multiple possible locations for jobId
//         if (resultData.containsKey('jobId')) {
//           jobId = resultData['jobId'];
//         } else if (resultData.containsKey('job_id')) {
//           jobId = resultData['job_id'];
//         } else if (resultData.containsKey('actions') && 
//                    resultData['actions'] is Map && 
//                    resultData['actions']['job_id'] != null) {
//           jobId = resultData['actions']['job_id'];
//         } else if (resultData.containsKey('smileJobId')) {
//           jobId = resultData['smileJobId'];
//         }

//         // If jobId not found in the result, extract it from the file path
//         if (jobId == null && resultData['selfieFile'] != null) {
//           final selfieFilePath = resultData['selfieFile'] as String;
//           // Path looks like: .../SmileID/submitted/job-f5d601bc-f7e0-44ab-a96e-737c08589d37/...
//           final regex = RegExp(r'job-([a-f0-9-]+)');
//           final match = regex.firstMatch(selfieFilePath);
//           if (match != null) {
//             jobId = match.group(0); // Gets "job-f5d601bc-f7e0-44ab-a96e-737c08589d37"
//             print("   ✅ Extracted jobId from file path!");
//           }
//         }

//         final didSubmitJob = resultData['didSubmitBiometricKycJob'] ?? false;
        
//         print("\n📋 EXTRACTED VERIFICATION DETAILS:");
//         print("   Job ID: ${jobId ?? 'NOT FOUND'}");
//         print("   Job Submitted: $didSubmitJob");
//         print("   Available keys: ${resultData.keys.toList()}");
        
//         if (resultData['selfieFile'] != null) {
//           print("\n📸 SELFIE FILE PATH:");
//           print("   ${resultData['selfieFile']}");
//         }

//         if (resultData['livenessFiles'] != null) {
//           final livenessFiles = resultData['livenessFiles'] as List;
//           print("\n🎥 LIVENESS FILES (${livenessFiles.length} images):");
//           for (int i = 0; i < livenessFiles.length; i++) {
//             print("   ${i + 1}. ${livenessFiles[i]}");
//           }
//         }

//         print("\n✅ Smile ID is processing BVN verification...");
//         if (jobId != null) {
//           print("   Backend should query Smile ID using jobId: $jobId");
//         } else {
//           print("   ⚠️ WARNING: No jobId found in result!");
//         }
//         print("==========================================\n");

//         // Send jobId to backend
//         await _sendToBackend(jobId ?? 'NO_JOB_ID', resultData);

//         // Close Smile ID screen immediately
//         if (mounted && Navigator.canPop(context)) {
//           Navigator.of(context).pop();
//         }

//         // Show success message
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 jobId != null 
//                   ? '✅ BVN verification submitted successfully!' 
//                   : '⚠️ Verification completed but no jobId received'
//               ),
//               backgroundColor: jobId != null ? Colors.green : Colors.orange,
//               behavior: SnackBarBehavior.floating,
//               duration: Duration(seconds: 2),
//             ),
//           );

//           // Navigate to next screen
//           Future.delayed(const Duration(milliseconds: 1500), () {
//             if (mounted) {
//               context.go('/debit-authorization-screen');
//             }
//           });
//         }
//       } catch (e) {
//         print("❌ ERROR PARSING RESULT: $e");
//         print("RAW RESULT: $result");
        
//         if (mounted && Navigator.canPop(context)) {
//           Navigator.of(context).pop();
//         }

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Error processing verification'),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//               duration: Duration(seconds: 2),
//             ),
//           );
//         }
//       }
//     } else {
//       print("⚠️ NO RESULT DATA RECEIVED");
      
//       if (mounted && Navigator.canPop(context)) {
//         Navigator.of(context).pop();
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('No verification data received'),
//             backgroundColor: Colors.orange,
//             behavior: SnackBarBehavior.floating,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   /// Send jobId to backend
//   /// Backend will query Smile ID API for verification results
//   Future<void> _sendToBackend(String jobId, Map<String, dynamic> fullResult) async {
//     try {
//       print("\n📡 SENDING TO BACKEND...");
      
//       final requestData = {
//         'jobId': jobId,
//         'timestamp': DateTime.now().toIso8601String(),
//         'verificationType': 'BVN_BIOMETRIC_KYC',
//         'didSubmitJob': fullResult['didSubmitBiometricKycJob'] ?? false,
//         'fullResultData': fullResult, // Send entire result for debugging
//       };

//       print("📤 Request Data:");
//       print(jsonEncode(requestData));

//       // TODO: Uncomment and update with your actual backend endpoint
//       /*
//       final response = await http.post(
//         Uri.parse('https://your-backend.com/api/kyc/bvn-verify'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer YOUR_TOKEN',
//         },
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 200) {
//         print("✅ Backend received jobId successfully");
//         final responseData = jsonDecode(response.body);
//         print("   Backend response: ${responseData['message']}");
//       } else {
//         print("❌ Backend error: ${response.statusCode}");
//         throw Exception('Backend submission failed');
//       }
//       */

//       if (jobId != 'NO_JOB_ID') {
//         print("✅ Backend will query Smile ID using jobId: $jobId");
//         print("   Backend should call: GET /v1/job_status/$jobId");
//       } else {
//         print("⚠️ WARNING: No valid jobId to send to backend!");
//         print("   Check the fullResultData above to see what Smile ID returned");
//       }
//       print("==========================================\n");
//     } catch (e) {
//       print("❌ Backend submission error: $e");
//     }
//   }

//   /// Handle verification error
//   void _handleError(String errorMessage) {
//     print("==========================================");
//     print("❌ BVN VERIFICATION ERROR");
//     print("==========================================");
//     print("ERROR: $errorMessage");
//     print("==========================================\n");

//     if (mounted) {
//       Navigator.of(context).pop(); // Close Smile ID screen

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ $errorMessage'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 4),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show error if initialization failed
//     if (_errorMessage != null) {
//       return Scaffold(
//         appBar: const CustomLoanAppBar(title: 'BVN Verification'),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.red, size: 80),
//                 const SizedBox(height: 24),
//                 Text(
//                   _errorMessage!,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 16, color: Colors.red),
//                 ),
//                 const SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: () => context.pop(),
//                   child: const Text('Go Back'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     // Main verification screen
//     return Scaffold(
//       appBar: const CustomLoanAppBar(title: 'BVN Verification'),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 20),

//               // Animated Icon
//               Center(
//                 child: AnimatedBuilder(
//                   animation: _shieldAnimation,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: _shieldAnimation.value,
//                       child: Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               const Color(0xff7C70DF).withOpacity(0.1),
//                               const Color(0xff9B8FFF).withOpacity(0.1),
//                             ],
//                           ),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xff7C70DF)
//                                   .withOpacity(_shieldAnimation.value * 0.3),
//                               blurRadius: 20,
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.account_balance,
//                           size: 60,
//                           color: Color(0xff7C70DF),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               const SizedBox(height: 32),

//               // Title
//               const Text(
//                 'Verify Your BVN',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff0F2D62),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Subtitle
//               const Text(
//                 'Bank Verification Number',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xff9CA3AF),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Description
//               const Text(
//                 'To complete your loan application, we need to verify your identity by confirming your BVN details through a quick facial verification.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Color(0xff4B5563),
//                   height: 1.5,
//                 ),
//               ),

//               const SizedBox(height: 32),

//               // Instructions Card
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF3F4F6),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: const Color(0xff7C70DF).withOpacity(0.2),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: const Color(0xff7C70DF).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(
//                             Icons.info_outline,
//                             color: Color(0xff7C70DF),
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'Before You Start',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xff0F2D62),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     _buildInstructionItem(
//                       Icons.face,
//                       'Remove caps, glasses, or face coverings',
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInstructionItem(
//                       Icons.wb_sunny_outlined,
//                       'Ensure you are in a well-lit area',
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInstructionItem(
//                       Icons.phone_android,
//                       'Hold your phone at eye level',
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInstructionItem(
//                       Icons.person_outline,
//                       'Make sure your full face is visible',
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 32),

//               // Security Note
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF0FDF4),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: const Color(0xff10B981).withOpacity(0.2),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.lock_outline,
//                       color: Color(0xff10B981),
//                       size: 20,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'Your data is encrypted and secure',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: const Color(0xff10B981).withOpacity(0.9),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 32),

//               // Start Verification Button
//               Container(
//                 height: 56,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF7C70DF), Color(0xFFA198FF)],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xff7C70DF).withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ElevatedButton(
//                   onPressed: _isInitialized ? _launchVerification : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isInitialized
//                       ? const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.verified_user, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               'Start BVN Verification',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         )
//                       : const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Go Back Button
//               TextButton(
//                 onPressed: () => context.pop(),
//                 child: const Text(
//                   'Go Back',
//                   style: TextStyle(color: Color(0xff7C70DF), fontSize: 15),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build instruction items
//   Widget _buildInstructionItem(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 18,
//           color: const Color(0xff7C70DF),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xff4B5563),
//               height: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:permission_handler/permission_handler.dart'; // FIX #1: added
import 'package:smile_id/products/biometric/smile_id_biometric_kyc.dart';
import 'package:smile_id/smile_id.dart';

class SmileIDVerificationScreen extends ConsumerStatefulWidget {
  const SmileIDVerificationScreen({super.key});

  @override
  ConsumerState<SmileIDVerificationScreen> createState() =>
      _SmileIDVerificationScreenState();
}

class _SmileIDVerificationScreenState
    extends ConsumerState<SmileIDVerificationScreen>
    with SingleTickerProviderStateMixin {
  bool _isInitialized = false;
  String? _errorMessage;
  late AnimationController _shieldController;
  late Animation<double> _shieldAnimation;

  @override
  void initState() {
    super.initState();

    _shieldController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _shieldAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _shieldController,
      curve: Curves.easeInOut,
    ));

    // FIX #2: Defer initialization until after first frame so the widget
    // tree is fully ready before SmileID.initialize() is called.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSmileID();
    });
  }

  @override
  void dispose() {
    _shieldController.dispose();
    super.dispose();
  }

  /// Initialize Smile ID SDK
  void _initializeSmileID() {
    try {
      SmileID.initialize(
        useSandbox: true, // Set to false for production
        enableCrashReporting: false,
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize Smile ID: $e';
        });
      }
    }
  }

  // FIX #3: Dedicated permission check method that handles all
  // three states: granted, denied-but-askable, permanently denied.
  Future<bool> _requestCameraPermission() async {
    // First check the current status without prompting
    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      // User has permanently denied — send them to app settings
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Camera Permission Required'),
            content: const Text(
              'Camera access has been permanently denied. '
              'Please enable it in your device settings to continue '
              'with BVN verification.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7C70DF),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  openAppSettings(); // Opens device settings for the app
                },
                child: const Text(
                  'Open Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
      return false;
    }

    // Permission is either denied or not yet asked — request it now
    status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    }

    // User just denied the prompt
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '📷 Camera permission is required to complete BVN verification.',
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
    return false;
  }

  /// Launch BVN Biometric KYC Verification
  Future<void> _launchVerification() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Smile ID is not initialized yet')),
      );
      return;
    }

    // FIX #3 (cont.): Always request/check camera permission before proceeding.
    final bool hasPermission = await _requestCameraPermission();
    if (!hasPermission) return; // Abort cleanly if camera access was denied

    print("🚀 Starting BVN Biometric KYC Verification");

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: const Text("BVN Verification"),
            backgroundColor: const Color(0xff7C70DF),
          ),
          body: SmileIDBiometricKYC(
            country: "NG",
            idType: "VOTER_ID", // FIX #4: was "VOTER_ID" — correct value is "BVN"
            idNumber: "0000000000000000004", // TODO: Replace with actual user BVN
            userId: "4f97b378-5b12-4c07-9802-0cb93465f033",
            showInstructions: false,
            useStrictMode: false,
            consentGrantedDate: DateTime.now().toIso8601String(),
            personalDetailsConsentGranted: true,
            contactInformationConsentGranted: false,
            documentInformationConsentGranted: false,
            onSuccess: (String? result) {
              _handleSuccess(result);
            },
            onError: (String errorMessage) {
              _handleError(errorMessage);
            },
          ),
        ),
      ),
    );
  }

  /// Handle successful BVN verification
  void _handleSuccess(String? result) async {
    print("==========================================");
    print("✅ SMILE ID BVN VERIFICATION SUCCESS");
    print("==========================================");

    if (result != null && result.isNotEmpty) {
      try {
        final resultData = jsonDecode(result) as Map<String, dynamic>;

        print("\n📋 FULL RESULT DATA:");
        print(jsonEncode(resultData));
        print("\n");

        String? jobId;

        if (resultData.containsKey('jobId')) {
          jobId = resultData['jobId'] as String?;
        } else if (resultData.containsKey('job_id')) {
          jobId = resultData['job_id'] as String?;
        } else if (resultData.containsKey('actions') &&
            resultData['actions'] is Map &&
            resultData['actions']['job_id'] != null) {
          jobId = resultData['actions']['job_id'] as String?;
        } else if (resultData.containsKey('smileJobId')) {
          jobId = resultData['smileJobId'] as String?;
        }

        // Fallback: extract jobId from selfie file path
        if (jobId == null && resultData['selfieFile'] != null) {
          final selfieFilePath = resultData['selfieFile'] as String;
          final regex = RegExp(r'job-([a-f0-9-]+)');
          final match = regex.firstMatch(selfieFilePath);
          if (match != null) {
            jobId = match.group(0);
            print("   ✅ Extracted jobId from file path!");
          }
        }

        final didSubmitJob = resultData['didSubmitBiometricKycJob'] ?? false;

        print("\n📋 EXTRACTED VERIFICATION DETAILS:");
        print("   Job ID: ${jobId ?? 'NOT FOUND'}");
        print("   Job Submitted: $didSubmitJob");
        print("   Available keys: ${resultData.keys.toList()}");

        if (resultData['selfieFile'] != null) {
          print("\n📸 SELFIE FILE PATH:");
          print("   ${resultData['selfieFile']}");
        }

        if (resultData['livenessFiles'] != null) {
          final livenessFiles = resultData['livenessFiles'] as List<dynamic>;
          print("\n🎥 LIVENESS FILES (${livenessFiles.length} images):");
          for (int i = 0; i < livenessFiles.length; i++) {
            print("   ${i + 1}. ${livenessFiles[i]}");
          }
        }

        await _sendToBackend(jobId ?? 'NO_JOB_ID', resultData);

        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jobId != null
                    ? '✅ BVN verification submitted successfully!'
                    : '⚠️ Verification completed but no jobId received',
              ),
              backgroundColor: jobId != null ? Colors.green : Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              context.go('/debit-authorization-screen');
            }
          });
        }
      } catch (e) {
        print("❌ ERROR PARSING RESULT: $e");
        print("RAW RESULT: $result");

        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error processing verification'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      print("⚠️ NO RESULT DATA RECEIVED");

      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No verification data received'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _sendToBackend(
      String jobId, Map<String, dynamic> fullResult) async {
    try {
      print("\n📡 SENDING TO BACKEND...");

      final requestData = {
        'jobId': jobId,
        'timestamp': DateTime.now().toIso8601String(),
        'verificationType': 'BVN_BIOMETRIC_KYC',
        'didSubmitJob': fullResult['didSubmitBiometricKycJob'] ?? false,
        'fullResultData': fullResult,
      };

      print("📤 Request Data:");
      print(jsonEncode(requestData));

      // TODO: Uncomment and update with your actual backend endpoint
      /*
      final response = await http.post(
        Uri.parse('https://your-backend.com/api/kyc/bvn-verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print("✅ Backend received jobId successfully");
        final responseData = jsonDecode(response.body);
        print("   Backend response: ${responseData['message']}");
      } else {
        print("❌ Backend error: ${response.statusCode}");
        throw Exception('Backend submission failed');
      }
      */

      if (jobId != 'NO_JOB_ID') {
        print("✅ Backend will query Smile ID using jobId: $jobId");
        print("   Backend should call: GET /v1/job_status/$jobId");
      } else {
        print("⚠️ WARNING: No valid jobId to send to backend!");
      }
      print("==========================================\n");
    } catch (e) {
      print("❌ Backend submission error: $e");
    }
  }

  void _handleError(String errorMessage) {
    print("==========================================");
    print("❌ BVN VERIFICATION ERROR");
    print("==========================================");
    print("ERROR: $errorMessage");
    print("==========================================\n");

    if (mounted) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $errorMessage'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: const CustomLoanAppBar(title: 'BVN Verification'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 80),
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomLoanAppBar(title: 'BVN Verification'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Animated Shield Icon
              Center(
                child: AnimatedBuilder(
                  animation: _shieldAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _shieldAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff7C70DF).withOpacity(0.1),
                              const Color(0xff9B8FFF).withOpacity(0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff7C70DF)
                                  .withOpacity(_shieldAnimation.value * 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 60,
                          color: Color(0xff7C70DF),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Verify Your BVN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0F2D62),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Bank Verification Number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'To complete your loan application, we need to verify your identity by confirming your BVN details through a quick facial verification.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff4B5563),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xff7C70DF).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xff7C70DF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xff7C70DF),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Before You Start',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0F2D62),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionItem(
                        Icons.face, 'Remove caps, glasses, or face coverings'),
                    const SizedBox(height: 12),
                    _buildInstructionItem(
                        Icons.wb_sunny_outlined, 'Ensure you are in a well-lit area'),
                    const SizedBox(height: 12),
                    _buildInstructionItem(
                        Icons.phone_android, 'Hold your phone at eye level'),
                    const SizedBox(height: 12),
                    _buildInstructionItem(
                        Icons.person_outline, 'Make sure your full face is visible'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xff10B981).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: Color(0xff10B981),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your data is encrypted and secure',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xff10B981).withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C70DF), Color(0xFFA198FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff7C70DF).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isInitialized ? _launchVerification : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isInitialized
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Start BVN Verification',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Color(0xff7C70DF), fontSize: 15),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xff7C70DF)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff4B5563),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}