import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String profileImageUrl;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    Key? key,
    required this.userName,
    required this.profileImageUrl,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xffFFFFFF),
      elevation: 0,
      leadingWidth: 100,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              'Hello, $userName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
                color: Color(0xff0F2D62),
              ),
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 14, color: Color(0xff4B5563)),
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              backgroundImage:
    profileImageUrl.isNotEmpty
        ? NetworkImage(profileImageUrl)
        : null,
child:
    profileImageUrl.isEmpty
        ? const Icon(Icons.person, color: Colors.grey)
        : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
