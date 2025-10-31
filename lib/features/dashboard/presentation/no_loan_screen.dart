import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_app_bar.dart';
import 'package:pcsloan/common/widgets/custom_bottom_nav_bar.dart';
import 'package:pcsloan/common/widgets/custom_circle_text_badge.dart';
import 'package:pcsloan/common/widgets/gradient_action_button.dart';
import 'package:pcsloan/utils/local_storage.dart';

class NoLoanScreen extends ConsumerStatefulWidget {
  const NoLoanScreen({super.key});

  @override
  ConsumerState<NoLoanScreen> createState() => _NoLoanScreen();
}

class _NoLoanScreen extends ConsumerState<NoLoanScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserNameOnce();
  }

  Future<void> _loadUserNameOnce() async {
    try {
      final data = await LocalStorage.getUser();
      print("object data: $data");
      final name = data?['first_name']?.toString().trim();
      if (!mounted) return;

      setState(() {
        _userName = (name?.isNotEmpty ?? false) ? name : null;
      });
    } catch (e, st) {
      debugPrint('❌ Failed to load username: $e\n$st');
      if (!mounted) return;
      setState(() => _userName = null);
    }
  }


  @override
  Widget build(BuildContext context) {
    
      final String profileImageUrl =
          "https://hirejourney.xyz/default_profile.png";
      final userName = _userName ?? "User";
      return Scaffold(
        
        backgroundColor: Color(0xffFFFFFF),
        appBar: CustomAppBar(
          userName: userName,
          profileImageUrl: profileImageUrl,
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoLoanScreen()),
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffA198FF).withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/pcs_text.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 9),
                      child: Text(
                        'Welcome to PCS Loan!',
                        style: TextStyle(
                          color: Color(0xff0F2D62),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        'Get started with your first loan application and',
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        'access fast, secure credit designed for civil',
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        'servants.',
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Container(
                        width: 346,
                        height: 212,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C70DF), Color(0xFFA198FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outlined,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                const Text(
                                  'Loan Benefits',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            const BenefitItem(
                              text: 'Competitive interest rates',
                            ),
                            const BenefitItem(text: 'Quick approval process'),
                            const BenefitItem(text: 'Flexible repayment terms'),
                            const BenefitItem(text: 'No hidden fees'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 11),
                      child: Text(
                        'How It Works',
                        style: TextStyle(
                          color: Color(0xff0F2D62),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleTextBadge(text: '1'),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),

                                    child: Text(
                                      "Apply Online",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff1F2937),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "Complete your loan application in just a few",
                                    style: TextStyle(
                                      color: Color(0xff4B5563),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "minutes",
                                    style: TextStyle(
                                      color: Color(0xff4B5563),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              CircleTextBadge(text: '2'),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),

                                    child: Text(
                                      "Get Approved",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff1F2937),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "Receive instant approval based on your profile",
                                    style: TextStyle(
                                      color: Color(0xff4B5563),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              CircleTextBadge(text: '3'),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),

                                    child: Text(
                                      "Receive Funds",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff1F2937),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "Money disbursed directly to your bank account",
                                    style: TextStyle(
                                      color: Color(0xff4B5563),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(
                                  Icons.shield,
                                  size: 22,
                                  color: Color(0xff0F2D62),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Eligibility Check',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8),
                            Text(
                              'Available for verified civil servants with a minimum of 6 months service record.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: GradientActionButton(
                        text: "+  Apply for a Loan",
                        size: 18,
                        onPressed: () {
                          context.push("/loan_application");
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Start your loan application today',
                        style: TextStyle(
                          color: Color(0xff6B7280),
                          fontFamily: "Inter",
                          fontSize: 14
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      );
    
  }
}

class BenefitItem extends StatelessWidget {
  final String text;

  const BenefitItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
