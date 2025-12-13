import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  final void Function()? onPersonalInfoTap;
  final void Function()? onChangePinTap;
  final void Function()? onNotificationsTap;
  final void Function()? onSecuritySettingsTap;

  const SettingsMenu({
    Key? key,
    this.onPersonalInfoTap,
    this.onChangePinTap,
    this.onNotificationsTap,
    this.onSecuritySettingsTap,
  }) : super(key: key);

  Widget _buildBoxedMenuItem({
    required IconData icon,
    required String label,
    required void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E0E0), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xffE5E7EB),
            child: Icon(icon, color: Color(0xff7C70DF)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBoxedMenuItem(
          icon: Icons.person,
          label: 'Personal Information',
          onTap: onPersonalInfoTap,
        ),
        _buildBoxedMenuItem(
          icon: Icons.lock,
          label: 'Manage Credentials',
          onTap: onChangePinTap,
        ),
        _buildBoxedMenuItem(
          icon: Icons.notifications,
          label: 'Notifications',
          onTap: onNotificationsTap,
        ),
        _buildBoxedMenuItem(
          icon: Icons.shield,
          label: 'Security Settings',
          onTap: onSecuritySettingsTap,
        ),
      ],
    );
  }
}
