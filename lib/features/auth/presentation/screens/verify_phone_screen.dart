import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';
import 'package:pcsloan/common/widgets/otp_count_down_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  String? _phoneNumber; // value we'll show in the Text widget
  bool _isLoading = true; // simple loading flag

  @override
  void initState() {
    super.initState();
    _loadPhoneNumberOnce();
  }

  Future<void> _loadPhoneNumberOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber');

    // update state exactly once
    setState(() {
      _phoneNumber = phoneNumber;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xff0F2D62)),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Verify Phone',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(0xff0F2D62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const SizedBox(height: 20),
              Text(
                'Enter the verfication code sent to',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),

              _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                    _phoneNumber == null || _phoneNumber!.isEmpty
                        ? 'No Phone-Number saved'
                        : '$_phoneNumber',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      color: Color(0xff0F2D62),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              const SizedBox(height: 30),

              Align(
                alignment: Alignment.center,
                child: PinCodeFields(
                  length: 6,
                  boxSize: 45,
                  onCompleted: (code) {
                    // send to backend / verify
                    print('User entered code: $code');
                  },
                ),
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timelapse_outlined,
                      color: Color(0xff908FDF),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Code expires in',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(width: 6),

                    OtpCountdown(totalSeconds: 180),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, right: 0),
                  child: SizedBox(
                    width: 342,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Verify Code",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 25),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn’t receive the code?",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xff4B5563),
                          fontSize: 14,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          return null;
                        },
                        child: Text(
                          "Click to resend",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffA198FF),
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    return null;
                  },
                  child: Text(
                    "Change Phone Number",
                    style: TextStyle(
                      fontSize: 16,
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
    );
  }
}
