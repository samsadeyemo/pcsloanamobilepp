import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_bottom_nav_bar.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:pcsloan/common/widgets/gradient_actions_icon_button.dart';
import 'package:pcsloan/common/widgets/reuseable_profile_card.dart';
import 'package:pcsloan/common/widgets/settings_menu.dart';
import 'package:pcsloan/common/widgets/support_section.dart';
import 'package:pcsloan/utils/local_storage.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _userName;
  String? _userLastName;
  String? _userEmail;
  String? _image_url;

  @override
  void initState() {
    super.initState();
    _loadBriefDataOnce();
  }

  Future<void> _loadBriefDataOnce() async {
    try {
      final data = await LocalStorage.getUser();
      print("object data: $data");
      final name = data?['first_name']?.toString().trim();
      final lastName = data?['last_name']?.toString().trim();
      final email = data?['email']?.toString().trim();
      final image_url = data?['profile_picture'];
      if (!mounted) return;

      setState(() {
        _userEmail = (email?.isNotEmpty ?? false) ? email : null;
        _userName = (name?.isNotEmpty ?? false) ? name : null;
        _userLastName = (lastName?.isNotEmpty ?? false) ? lastName : null;
        _image_url = (image_url?.isNotEmpty ?? false) ? image_url : null;
      });
    } catch (e, st) {
      debugPrint('❌ Failed to load username: $e\n$st');
      if (!mounted) return;
      setState(() => _userName = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userName ?? "User";
    final userLastName = _userLastName ?? "";
    final email = _userEmail ?? "";
    final imageUrl = _image_url ?? "";
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: CustomLoanAppBar(title: 'Profile Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCard(
                  firstName: userName,
                  lastName: userLastName,
                  email: email,
                  imageUrl: imageUrl, // or provide a URL for the profile photo
                ),
                SizedBox(height: 20),
                SettingsMenu(
                  onPersonalInfoTap:
                      () => context.push('/personal-information'),
                  onChangePinTap:
                      () => Navigator.pushNamed(context, '/change-pin'),
                  onNotificationsTap:
                      () => Navigator.pushNamed(context, '/notifications'),
                  onSecuritySettingsTap:
                      () => Navigator.pushNamed(context, '/security-settings'),
                ),
                SizedBox(height: 30),
                SupportMenu(
                  // onHelpCenterTap:
                  //     () => Navigator.pushNamed(context, '/help-center'),
                  onContactSupportTap:
                      () => Navigator.pushNamed(context, '/contact-support'),
                ),
                SizedBox(height: 30),

                GradientIconActionButton(
                  icon: Icons.exit_to_app,
                  text: "Logout",
                  onPressed: () => context.go("/signin"),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}
