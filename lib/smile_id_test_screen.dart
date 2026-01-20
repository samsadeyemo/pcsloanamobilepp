import 'package:flutter/material.dart';
import 'package:smile_id/products/biometric/smile_id_biometric_kyc.dart';
import 'package:smile_id/smile_id.dart';

class SmileIDTestScreen extends StatefulWidget {
  const SmileIDTestScreen({Key? key}) : super(key: key);

  @override
  State<SmileIDTestScreen> createState() => _SmileIDTestScreenState();
}

class _SmileIDTestScreenState extends State<SmileIDTestScreen> {
  String _statusMessage = "Ready to test Smile ID";
  String _lastResult = "";

  @override
  void initState() {
    super.initState();
    _initializeSmileID();
  }

  // Initialize Smile ID SDK
  void _initializeSmileID() {
    try {
      setState(() {
        _statusMessage = "Initializing Smile ID...";
      });

      // Initialize - reads from smile_config.json automatically
      SmileID.initialize(
        useSandbox: true, // Set to false for production
        enableCrashReporting: false,
      );

      setState(() {
        _statusMessage = "✅ Smile ID initialized successfully!\n\nTap button below to start BVN verification";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "❌ Initialization failed: $e";
      });
    }
  }

  // Launch Smile ID BVN verification
  void _launchBVNVerification() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: const Text("SmileID Biometric KYC"),
            backgroundColor: Colors.blue,
          ),
          body: SmileIDBiometricKYC(
            country: "NG", // Nigeria
            idType: "BVN", // Bank Verification Number
            idNumber: "", // Leave empty - user will enter in the SDK
            showInstructions: true, // Show instruction screen
            useStrictMode: false, // Set to true for enhanced SmartSelfie™ capture
            consentGrantedDate: DateTime.now().toIso8601String(), // Consent date
            personalDetailsConsentGranted: true, // User agreed to personal details
            contactInformationConsentGranted: false, // Set based on your consent flow
            documentInformationConsentGranted: false, // Set based on your consent flow
            onSuccess: (String? result) {
              // Success - liveness passed, image captured
              print("=== SUCCESS ===");
              print("Result: $result");

              // Show success message
              final snackBar = SnackBar(
                content: Text("✅ Verification completed successfully!"),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // Return to main screen
              Navigator.of(context).pop();

              // Update status
              setState(() {
                _lastResult = result ?? "No result data";
                _statusMessage = """
✅ Verification Completed!

📸 Selfie captured successfully
✅ Liveness check passed
📄 BVN information collected

Result: $result

⚠️ Important: The SDK only validates:
  • Image quality
  • Liveness detection
  • User completed the flow

Real BVN verification happens on Smile ID servers after you send this data to your backend!

Now send this to your backend for final validation.
                """;
              });

              // Send to backend
              _sendToBackend(result);
            },
            onError: (String errorMessage) {
              // Error or user cancelled
              print("=== ERROR ===");
              print("Error: $errorMessage");

              // Show error message
              final snackBar = SnackBar(
                content: Text("❌ Error: $errorMessage"),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // Return to main screen
              Navigator.of(context).pop();

              // Update status
              setState(() {
                _statusMessage = "❌ Verification failed or cancelled\n\nError: $errorMessage";
              });
            },
          ),
        ),
      ),
    );
  }

  // Send captured data to backend
  Future<void> _sendToBackend(String? result) async {
    print("=== SENDING TO BACKEND ===");
    print("Result data: $result");

    // TODO: Implement your API call here
    // Example:
    // try {
    //   final response = await http.post(
    //     Uri.parse('https://your-backend.com/api/verify-bvn'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       'result': result,
    //       'timestamp': DateTime.now().toIso8601String(),
    //     }),
    //   );
    //   
    //   if (response.statusCode == 200) {
    //     print("Successfully sent to backend");
    //   }
    // } catch (e) {
    //   print("Error sending to backend: $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smile ID BVN Test'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Status Icon
              Icon(
                _statusMessage.contains('✅')
                    ? Icons.check_circle
                    : _statusMessage.contains('❌')
                        ? Icons.error
                        : Icons.info,
                size: 80,
                color: _statusMessage.contains('✅')
                    ? Colors.green
                    : _statusMessage.contains('❌')
                        ? Colors.red
                        : Colors.blue,
              ),
              const SizedBox(height: 24),

              // Status Message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Start Verification Button
              ElevatedButton.icon(
                onPressed: _launchBVNVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.verified_user, color: Colors.white),
                label: const Text(
                  'Start BVN Verification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue[100]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'How it works:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Tap the button above\n'
                      '2. Read instructions\n'
                      '3. Enter your BVN number\n'
                      '4. Take a selfie\n'
                      '5. Liveness check happens automatically\n'
                      '6. Result returns to app\n'
                      '7. Send data to your backend',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Important Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The SDK only checks if you\'re a real person and captures good images. Real BVN validation happens on Smile ID servers!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange[900],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}