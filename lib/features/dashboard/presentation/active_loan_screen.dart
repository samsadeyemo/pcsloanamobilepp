import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_app_bar.dart';

class ActiveLoanScreen extends ConsumerStatefulWidget {
  const ActiveLoanScreen({super.key});

  @override
  ConsumerState<ActiveLoanScreen> createState() => _ActiveLoanScreen();
}

class _ActiveLoanScreen extends ConsumerState<ActiveLoanScreen> {
  @override
  Widget build(BuildContext context) {
      final String profileImageUrl =
          "https://fareedtijani.vercel.app/assets/FareedTijani-BrMuVf91.jpg";

    return Scaffold(
      appBar: CustomAppBar(
        userName: 'Fareed',
        profileImageUrl: profileImageUrl,
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ActiveLoanScreen()),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ActiveLoanScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ActiveLoanScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ActiveLoanScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Page 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],),
    );
  }
}


