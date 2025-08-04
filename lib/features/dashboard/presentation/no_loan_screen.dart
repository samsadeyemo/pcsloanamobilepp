import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_app_bar.dart';
import 'package:pcsloan/common/widgets/custom_bottom_nav_bar.dart';

class NoLoanScreen extends ConsumerStatefulWidget {
  const NoLoanScreen({super.key});

  @override
  ConsumerState<NoLoanScreen> createState() => _NoLoanScreen();
}

class _NoLoanScreen extends ConsumerState<NoLoanScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    {
      final String profileImageUrl =
          "https://fareedtijani.vercel.app/assets/FareedTijani-BrMuVf91.jpg";

      return Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        appBar: CustomAppBar(
          userName: 'Fareed',
          profileImageUrl: profileImageUrl,
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoLoanScreen()),
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                  
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
