

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_activity_bottom_nav_bar.dart';

class ActivityTab extends ConsumerStatefulWidget {
  const ActivityTab({super.key});

  @override
  ConsumerState<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends ConsumerState<ActivityTab> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: Text(
            "Activity",
            style: TextStyle(
              color: Color(0xff0F2D62),
              fontSize: 18,
              fontFamily: "Inter"
              ), 
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffFFFFFF),
      ),
      bottomNavigationBar: CustomActionBottomNavBar(),
    );
  }
}