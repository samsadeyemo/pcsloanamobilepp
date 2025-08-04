import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoLoanScreen extends ConsumerStatefulWidget {
  const NoLoanScreen({super.key});

  @override
  ConsumerState<NoLoanScreen> createState() => _NoLoanScreen();
}

class _NoLoanScreen extends ConsumerState<NoLoanScreen> {
  @override
  Widget build(BuildContext context) {
    { final String profileImageUrl = "https://fareedtijani.vercel.app/assets/FareedTijani-BrMuVf91.jpg";


      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffFFFFFF),
          elevation: 0,
          leadingWidth: 100,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  'Hello, Fareed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),

           actions: [
    Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to profile or settings
        },
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[200],
          backgroundImage: NetworkImage(profileImageUrl),
          child: profileImageUrl == null || profileImageUrl.isEmpty
              ? Icon(Icons.person, color: Colors.grey)
              : null,
        ),
      ),
    ),
  ],
        ),
      );
    }
  }
}
