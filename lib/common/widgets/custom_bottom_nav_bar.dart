import 'package:flutter/material.dart';
import 'package:pcsloan/features/activity/presentation/activity_tab.dart';
import 'package:pcsloan/features/dashboard/presentation/no_loan_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/apply_for_loan.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex; // index of the current active tab

  const CustomBottomNavBar({super.key, this.currentIndex = 0});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return; // skip redundant taps

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NoLoanScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ApplyForLoan()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ActivityTab()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ActivityTab()), // placeholder for Profile
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xffFFFFFF),
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
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
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Activity'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
