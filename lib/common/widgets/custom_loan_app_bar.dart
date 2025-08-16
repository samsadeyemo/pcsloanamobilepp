import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomLoanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomLoanAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        width: 40,
        child: Center(
          child: GestureDetector(
            onTap: () {
              context.go('/previousRoute'); // Replace with your actual route
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffF3F4F6),
              ),
              child: Center(
                child: FittedBox(
                  child: Icon(
                    Icons.arrow_back_sharp,
                    size: 20,
                    color: Color(0xff4B5563),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
