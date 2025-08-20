import 'package:flutter/material.dart';

class CustomLoanAppBarFalse extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomLoanAppBarFalse({Key? key, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xffFFFFFF),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xff0F2D62),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
