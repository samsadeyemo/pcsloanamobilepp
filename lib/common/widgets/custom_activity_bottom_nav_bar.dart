import 'package:flutter/material.dart';
import 'package:pcsloan/features/activity/presentation/activity_tab.dart';
import 'package:pcsloan/features/dashboard/presentation/no_loan_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/apply_for_loan.dart';
import 'package:pcsloan/features/profile/presentation/profile_screen.dart';

class CustomActionBottomNavBar extends StatelessWidget {
  const CustomActionBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 2;

    return StatefulBuilder(
      builder: (context, setState) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xffFFFFFF),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NoLoanScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ApplyForLoan()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
                break;
              
            }
          },
          selectedItemColor: const Color(0xff7C70DF),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff7C70DF),
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Loan'),
            // BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Activity'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}