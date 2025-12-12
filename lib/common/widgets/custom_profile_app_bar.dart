import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomProfileAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        width: 40,
        child: Center(
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xff7C70DF),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
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