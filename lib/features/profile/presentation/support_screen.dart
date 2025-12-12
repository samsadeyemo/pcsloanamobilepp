import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_profile_app_bar.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF7C70DF),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSupportOption(String option) {
    // TODO: Implement navigation to respective screens when available
    _showSnackBar('$option - Coming soon!');
  }

  void _handleContactMethod(String method) {
    // TODO: Implement contact method functionality (phone, email, WhatsApp)
    _showSnackBar('Opening $method - Coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: const CustomProfileAppBar(title: "Support"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with gradient
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7C70DF),
                      Color(0xFF9B8FE8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.support_agent,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'How can we help you?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our support team is available to assist you',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Support Options List
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    // Chat with support team
                    _buildSupportOptionCard(
                      icon: Icons.chat_bubble_outline,
                      title: 'Chat with our support team',
                      iconColor: const Color(0xFF7C70DF),
                      onTap: () => _handleSupportOption('Chat with support team'),
                    ),
                    const SizedBox(height: 12),

                    // Frequently asked questions
                    _buildSupportOptionCard(
                      icon: Icons.help_outline,
                      title: 'Frequently asked questions',
                      iconColor: const Color(0xFF7C70DF),
                      onTap: () => _handleSupportOption('FAQ'),
                    ),
                    const SizedBox(height: 12),

                    // Speak directly with an agent
                    _buildSupportOptionCard(
                      icon: Icons.phone_outlined,
                      title: 'Speak directly with an agent',
                      iconColor: const Color(0xFF7C70DF),
                      onTap: () => _handleSupportOption('Speak with agent'),
                    ),
                    const SizedBox(height: 12),

                    // Send us an email
                    _buildSupportOptionCard(
                      icon: Icons.email_outlined,
                      title: 'Send us an email',
                      iconColor: const Color(0xFF7C70DF),
                      onTap: () => _handleSupportOption('Send email'),
                    ),
                    const SizedBox(height: 12),

                    // Book a call at your convenience
                    _buildSupportOptionCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'Book a call at your convenience',
                      iconColor: const Color(0xFF7C70DF),
                      onTap: () => _handleSupportOption('Book a call'),
                    ),

                    const SizedBox(height: 32),

                    // Emergency Contact Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'For urgent issues, please contact us directly',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildContactButton(
                                icon: Icons.phone,
                                label: 'Call',
                                color: const Color(0xFF2563EB),
                                onTap: () => _handleContactMethod('Call'),
                              ),
                              const SizedBox(width: 20),
                              _buildContactButton(
                                icon: Icons.email,
                                label: 'Email',
                                color: const Color(0xFF7C70DF),
                                onTap: () => _handleContactMethod('Email'),
                              ),
                              const SizedBox(width: 20),
                              _buildContactButton(
                                icon: Icons.chat,
                                label: 'WhatsApp',
                                color: const Color(0xFF25D366),
                                onTap: () => _handleContactMethod('WhatsApp'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Support Hours: 8am - 6pm Mon-Fri',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Emergency Contact: +234 800 000 0000',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportOptionCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}