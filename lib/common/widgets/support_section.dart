import 'package:flutter/material.dart';

class SupportMenu extends StatelessWidget {
  final void Function()? onHelpCenterTap;
  final void Function()? onContactSupportTap;

  const SupportMenu({
    Key? key,
    this.onHelpCenterTap,
    this.onContactSupportTap,
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
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xff7C70DF)),
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
        // _buildBoxedMenuItem(
        //   icon: Icons.help_outline,
        //   label: 'Help Center',
        //   onTap: onHelpCenterTap,
        // ),
        _buildBoxedMenuItem(
          icon: Icons.headset_mic,
          label: 'Contact Support',
          onTap: onContactSupportTap,
        ),
      ],
    );
  }
}
