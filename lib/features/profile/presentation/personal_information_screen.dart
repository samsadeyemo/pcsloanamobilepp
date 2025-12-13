import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:pcsloan/common/widgets/custom_profile_app_bar.dart';
import 'package:pcsloan/service/cloudinary_service.dart';
import 'package:pcsloan/service/profile_sevice.dart';
import 'package:pcsloan/utils/local_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _personalInformationScreenState();
}

class _personalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  bool _fetching = false;
  bool _isUploadingProfilePicture = false;
  final _cloudinaryService = CloudinaryService();
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
        await LocalStorage.clearUser();

        await LocalStorage.saveUser(result['data']);
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

  // Show bottom sheet to select Camera or Gallery
  Future<ImageSource?> _showImageSourceBottomSheet() async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Image Source',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.white),
                  ),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
    );
  }

  // Compress image if size > 5MB
  Future<File?> _compressImageIfNeeded(File imageFile) async {
    try {
      final fileSize = await imageFile.length();
      final fileSizeInMB = fileSize / (1024 * 1024);

      if (fileSizeInMB <= 5) {
        return imageFile;
      }

      _showSnackBar('Compressing image...', isError: false);

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '${imageFile.parent.path}/compressed_${imageFile.path.split('/').last}',
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
      );

      return compressedFile != null ? File(compressedFile.path) : imageFile;
    } catch (e) {
      print('Error compressing image: $e');
      return imageFile;
    }
  }

  // Request permissions
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    }

    final result = await permission.request();
    return result.isGranted;
  }

  String _maskString(String value, {int visibleCount = 4}) {
    if (value.isEmpty) return '';
    if (value.length <= visibleCount) return value;
    final masked = '*' * (value.length - visibleCount);
    return '$masked${value.substring(value.length - visibleCount)}';
  }

  Future<void> _handleProfilePictureUpload() async {
    try {
      // Step 1: Show bottom sheet to select source
      final source = await _showImageSourceBottomSheet();
      if (source == null) return;

      // Step 2: Request permission based on source
      final permission =
          source == ImageSource.camera ? Permission.camera : Permission.photos;

      final hasPermission = await _requestPermission(permission);
      if (!hasPermission) {
        _showSnackBar(
          'Permission denied. Please enable it in settings.',
          isError: true,
        );
        return;
      }

      // Step 3: Pick image
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) return;

      // Step 4: Show loading on profile picture
      setState(() => _isUploadingProfilePicture = true);

      // Step 5: Compress image if needed
      File? imageFile = File(pickedFile.path);
      imageFile = await _compressImageIfNeeded(imageFile);

      if (imageFile == null) {
        throw Exception('Failed to process image');
      }

      // Step 6: Delete old profile picture from Cloudinary (if exists)
      if (profilePicture.isNotEmpty) {
        _showSnackBar('Removing old picture...', isError: false);
        await _cloudinaryService.deleteImage(profilePicture);
      }

      // Step 7: Upload new image to Cloudinary
      _showSnackBar('Uploading new picture...', isError: false);
      final imageUrl = await _cloudinaryService.uploadImage(imageFile);

      // Step 8: Update backend with new URL
      final result = await _profileService.editUserProfilePicture(
        imageUrl: imageUrl,
      );

      if (result['status'] == 'success') {
        // Step 9: Update UI
        await LocalStorage.clearUser();

        await LocalStorage.saveUser(result['data']);
        setState(() {
          profilePicture = imageUrl;
        });
        _showSnackBar('Profile picture updated successfully!');
      } else {
        throw Exception(
          result['message'] ?? 'Failed to update profile picture',
        );
      }
    } catch (e) {
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      // Step 10: Hide loading
      if (mounted) {
        setState(() => _isUploadingProfilePicture = false);
      }
    }
  }

  void _showEditEmailDialog() {
    final TextEditingController emailController = TextEditingController(
      text: email,
    );
    bool isLoading = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Edit Email'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xff7C70DF),
                              width: 2,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      if (isLoading) ...[
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(
                          color: Color(0xff7C70DF),
                          strokeWidth: 3,
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed:
                          isLoading ? null : () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color:
                              isLoading ? Colors.grey : const Color(0xff7C70DF),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isLoading
                                  ? [Colors.grey, Colors.grey]
                                  : [
                                    const Color(0xff7C70DF),
                                    const Color(0xffA198FF),
                                  ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  final newEmail = emailController.text.trim();

                                  // Basic email validation
                                  if (newEmail.isEmpty) {
                                    _showSnackBar(
                                      'Please enter an email address',
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (!newEmail.contains('@') ||
                                      !newEmail.contains('.')) {
                                    _showSnackBar(
                                      'Please enter a valid email address',
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (newEmail == email) {
                                    Navigator.pop(context);
                                    _showSnackBar(
                                      'Email is already up to date',
                                    );
                                    return;
                                  }

                                  // Show loading
                                  setDialogState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    // Call API to update email
                                    final result = await _profileService
                                        .editUserEmail(emailAddress: newEmail);
                                    print(result);
                                    if (result['status'] == 'success') {
                                      setState(() {
                                        email = newEmail;
                                      });
                                      await LocalStorage.clearUser();

                                      await LocalStorage.saveUser(
                                        result['data'],
                                      );
                                      Navigator.pop(context);
                                      _showSnackBar(
                                        'Email updated successfully',
                                      );
                                    } else {
                                      throw Exception(
                                        result['message'] ??
                                            'Failed to update email',
                                      );
                                    }
                                  } catch (e) {
                                    _showSnackBar(
                                      e.toString().replaceFirst(
                                        'Exception: ',
                                        '',
                                      ),
                                      isError: true,
                                    );
                                  } finally {
                                    if (context.mounted) {
                                      setDialogState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    bool isEditable = false,
    bool isMasked = false, // Add this parameter
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
                    fontFamily:
                        isMasked
                            ? 'monospace'
                            : null, // Use monospace for masked values
                    letterSpacing: isMasked ? 1.5 : null, // Add letter spacing
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
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
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
      appBar: CustomProfileAppBar(title: "Personal Information"),
      body:
          _fetching
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
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          profilePicture.isNotEmpty
                                              ? NetworkImage(profilePicture)
                                              : null,
                                      child:
                                          profilePicture.isEmpty
                                              ? Icon(
                                                Icons.person,
                                                size: 60,
                                                color: const Color(
                                                  0xff7C70DF,
                                                ).withOpacity(0.5),
                                              )
                                              : null,
                                    ),
                                    // Loading overlay
                                    if (_isUploadingProfilePicture)
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap:
                                      _isUploadingProfilePicture
                                          ? null
                                          : _handleProfilePictureUpload,
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
                                    child: Icon(
                                      Icons.camera_alt,
                                      color:
                                          _isUploadingProfilePicture
                                              ? Colors.grey
                                              : const Color(0xff7C70DF),
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
                          _buildInfoCard(label: 'Bank Name', value: bankName),
                          _buildInfoCard(
                            label: 'Account Number',
                            value: _maskString(accountNumber),
                            isMasked: true,
                          ),
                          _buildInfoCard(
                            label: 'BVN',
                            value: _maskString(bvn),
                            isMasked: true,
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
