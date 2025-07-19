import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  ConsumerState<CreatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  bool _obscurePassword = true;
  bool _obscurePassword1 = true;

  String password = "";
  String password1 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text(
                  'Create Password',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(0xff0F2D62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const SizedBox(height: 20),
              Text(
                'Set a strong password to secure your account',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F2D62),
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Color(0xff6B7280), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        obscureText: _obscurePassword,
                        onChanged: (value) => password = value,
                        validator:
                            (value) =>
                                value != null && value.length >= 6
                                    ? null
                                    : "Password too short try again",
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Create a strong password',
                          hintStyle: TextStyle(
                            color: Color(0xFFADAEBC),
                            fontSize: 16,
                            fontFamily: "Inter",
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          // contentPadding: EdgeInsets.zero,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xff9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.info, color: Color(0xffA198FF), size: 12),
                  SizedBox(width: 10),
                  Text(
                    'Password must be at least 8 characters long',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4B5563),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F2D62),
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Color(0xff6B7280), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        obscureText: _obscurePassword1,
                        onChanged: (value) => password1 = value,
                        validator:
                            (value) =>
                                value != null && value.length >= 6
                                    ? null
                                    : "Password too short try again",
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(
                            color: Color(0xFFADAEBC),
                            fontSize: 16,
                            fontFamily: "Inter",
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          // contentPadding: EdgeInsets.zero,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword1 = !_obscurePassword1;
                              });
                            },
                            icon: Icon(
                              _obscurePassword1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xff9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 342,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_obscurePassword == _obscurePassword1) {
                          context.go("");
                        }
                      },
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
                            "Continue",
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
