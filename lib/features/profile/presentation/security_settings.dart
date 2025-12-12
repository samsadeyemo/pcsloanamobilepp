// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pcsloan/common/widgets/custom_profile_app_bar.dart';

// class SecuritySettings extends ConsumerStatefulWidget {
//   const SecuritySettings({super.key});

//   @override
//   ConsumerState<SecuritySettings> createState() => _SecuritySettings();
// }

// class _SecuritySettings extends ConsumerState<SecuritySettings> {
//   bool _isBiometricEnabled = false;

//   void _showDeleteAccountDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Delete Account',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         ),
//         content: const Text(
//           'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
//           style: TextStyle(fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Color(0xFF7C70DF)),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // TODO: Implement account deletion logic
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Account deletion requested'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               },
//               child: const Text(
//                 'Delete',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F5),
//       appBar: CustomProfileAppBar(title: "Security Settings"),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Authentication',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF7C70DF),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
                
//                 // Biometric Toggle Card
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF7C70DF),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(
//                           Icons.fingerprint,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Enable Biometric',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Use fingerprint or face ID to login',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Switch(
//                         value: _isBiometricEnabled,
//                         onChanged: (value) {
//                           setState(() {
//                             _isBiometricEnabled = value;
//                           });
//                           // TODO: Implement biometric logic
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 value
//                                     ? 'Biometric enabled'
//                                     : 'Biometric disabled',
//                               ),
//                               backgroundColor: const Color(0xFF7C70DF),
//                               duration: const Duration(seconds: 2),
//                             ),
//                           );
//                         },
//                         activeColor: const Color(0xFF7C70DF),
//                         activeTrackColor: const Color(0xFF7C70DF).withOpacity(0.5),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 const Text(
//                   'Danger Zone',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Delete Account Button
//                 InkWell(
//                   onTap: _showDeleteAccountDialog,
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.red.withOpacity(0.3)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.red.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Icon(
//                             Icons.delete_forever,
//                             color: Colors.red,
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Delete Account',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Permanently delete your account and data',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.red,
//                           size: 18,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pcsloan/common/widgets/custom_profile_app_bar.dart';
import 'package:pcsloan/utils/local_storage.dart';

class SecuritySettings extends ConsumerStatefulWidget {
  const SecuritySettings({super.key});

  @override
  ConsumerState<SecuritySettings> createState() => _SecuritySettings();
}

class _SecuritySettings extends ConsumerState<SecuritySettings> {
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  bool _isLoading = true;
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _initializeBiometric();
  }

  Future<void> _initializeBiometric() async {
    try {
      // Check if device supports biometrics
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final types = await _auth.getAvailableBiometrics();
      
      final available = isSupported && canCheck && types.isNotEmpty;
      
      // Get user's saved preference
      final isEnabled = await LocalStorage.isBiometricEnabled();
      
      if (mounted) {
        setState(() {
          _isBiometricAvailable = available;
          _isBiometricEnabled = isEnabled && available; // Only enabled if device supports it
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Biometric initialization error: $e');
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
          _isBiometricEnabled = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (!_isBiometricAvailable) {
      _showSnackBar(
        'Biometric authentication is not available on this device',
        isError: true,
      );
      return;
    }

    // Check if user has logged in before
    // final hasLoginBefore = await LocalStorage.hasLoginBefore();
    // if (!hasLoginBefore) {
    //   _showSnackBar(
    //     'Please login at least once before enabling biometric authentication',
    //     isError: true,
    //   );
    //   return;
    // }

    if (value) {
      // User wants to ENABLE biometric - verify it works first
      try {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Verify your identity to enable biometric login',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (!mounted) return;

        if (authenticated) {
          // Save the preference
          await LocalStorage.setBiometricEnabled(true);
          setState(() => _isBiometricEnabled = true);
          _showSnackBar('Biometric login enabled successfully',isError: false);
        } else {
          _showSnackBar('Authentication failed. Biometric not enabled', isError: true);
        }
      } catch (e) {
        debugPrint('Biometric auth error: $e');
        if (mounted) {
          _showSnackBar('Failed to enable biometric: $e', isError: true);
        }
      }
    } else {
      // User wants to DISABLE biometric - just save preference
      await LocalStorage.setBiometricEnabled(false);
      setState(() => _isBiometricEnabled = false);
      _showSnackBar('Biometric login disabled');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7C70DF)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement account deletion logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion requested'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: CustomProfileAppBar(title: "Security Settings"),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Authentication',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7C70DF),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Biometric Toggle Card
                      Opacity(
                        opacity: _isBiometricAvailable ? 1.0 : 0.5,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C70DF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.fingerprint,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Enable Biometric',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _isBiometricAvailable
                                          ? 'Use fingerprint or face ID to login'
                                          : 'Not available on this device',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isBiometricEnabled,
                                onChanged: _isBiometricAvailable ? _toggleBiometric : null,
                                activeColor: const Color(0xFF7C70DF),
                                activeTrackColor: const Color(0xFF7C70DF).withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Danger Zone',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Delete Account Button
                      InkWell(
                        onTap: _showDeleteAccountDialog,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delete Account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Permanently delete your account and data',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.red,
                                size: 18,
                              ),
                            ],
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
}