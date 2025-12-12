import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:pcsloan/service/profile_sevice.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _personalInformationScreenState();
}

class _personalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  bool _fetching = false;
  final _profileService = ProfileService();
  String userName = "";
  String email = "";
  String phoneNumber = "";
  String bankName = "";
  String accountNumber = "";
  String bvn = "";
  String profilePicture = "";

  @override
  void initState() {
    super.initState();
    _loadPersonalInformation();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _loadPersonalInformation() async {
    setState(() => _fetching = true);

    try {
      final result = await _profileService.fetchUserProfile();

      if (result.isNotEmpty) {
        setState(() {
          userName =
              "${result['data']['first_name']} ${result['data']['last_name']}";
          email = result['data']['email'] ?? '';
          phoneNumber = result['data']['phone'] ?? '';
          bankName = result['data']['bank_details']['bank_name'] ?? '';
          accountNumber =
              result['data']['bank_details']['account_number'] ?? '';
          bvn = result['data']['bank_details']['bvn'] ?? '';
          profilePicture = result['data']['profile_picture'] ?? '';
        });
      }
    } catch (e) {
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _fetching = false);
      }
    }
  }


  
  String _maskString(String value, {int visibleCount = 4}) {
    if (value.isEmpty) return '';
    if (value.length <= visibleCount) return value;
    final masked = '*' * (value.length - visibleCount);
    return '$masked${value.substring(value.length - visibleCount)}';
  }

  void _handleProfilePictureUpload() {
    // TODO: Implement image picker
    _showSnackBar('Profile picture upload - implement image picker');
  }

  void _showEditEmailDialog() {
    final TextEditingController emailController =
        TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Email'),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff7C70DF), width: 2),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xff7C70DF))),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff7C70DF), Color(0xffA198FF)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  email = emailController.text;
                });
                Navigator.pop(context);
                _showSnackBar('Email updated successfully');
                // TODO: Call API to update email
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    bool isEditable = false,
    VoidCallback? onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value.isEmpty ? 'Not provided' : value,
                  style: TextStyle(
                    fontSize: 16,
                    color: value.isEmpty ? Colors.grey[400] : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            InkWell(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: CustomLoanAppBar(title: "Personal Information"),
      body: _fetching
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section with Profile Picture
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                backgroundImage: profilePicture.isNotEmpty
                                    ? NetworkImage(profilePicture)
                                    : null,
                                child: profilePicture.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: const Color(0xff7C70DF)
                                            .withOpacity(0.5),
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _handleProfilePictureUpload,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Color(0xff7C70DF),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userName.isEmpty ? 'User Name' : userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // Personal Information Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7C70DF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          label: 'Email Address',
                          value: email,
                          isEditable: true,
                          onEdit: _showEditEmailDialog,
                        ),
                        _buildInfoCard(
                          label: 'Phone Number',
                          value: "+$phoneNumber",
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Bank Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7C70DF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          label: 'Bank Name',
                          value: bankName,
                        ),
                        _buildInfoCard(
                          label: 'Account Number',
                          value: _maskString(accountNumber),
                        ),
                        _buildInfoCard(
                          label: 'BVN',
                          value: _maskString(bvn),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}