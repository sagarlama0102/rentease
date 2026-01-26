import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/app/theme/app_colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentease/app/theme/theme_extensions.dart';
import 'package:rentease/core/utils/snackbar_utils.dart';
import 'package:rentease/features/auth/presentation/state/auth_state.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  final String _baseUrl = "http://192.168.101.11:4000";
  String? _selectedMediaType;
  String? _profilePictureUrl;

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // code for camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    debugPrint("Camera Permission Status: $hasPermission");
    if (!hasPermission) return;

    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(photo);
          _selectedMediaType = 'photo';
        });
        // Upload photo to server
        await ref
            .read(authViewModelProvider.notifier)
            .uploadPhoto(File(photo.path));
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  // code for gallery
  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.addAll(images);
            _selectedMediaType = 'photo';
          });
          // Upload first photo to server
          await ref
              .read(authViewModelProvider.notifier)
              .uploadPhoto(File(images.first.path));
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.add(image);
            _selectedMediaType = 'photo';
          });
          // Upload photo to server
          await ref
              .read(authViewModelProvider.notifier)
              .uploadPhoto(File(image.path));
        }
      }
    } catch (e) {
      debugPrint('Gallery Error $e');

      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  // code for dialogBox : showDialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.browse_gallery),
                title: Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.created) {
        SnackbarUtils.showSuccess(context, "Profile picture updated");
        Navigator.pop(context);
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.authPrimary, AppColors.authPrimary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 22),

                    GestureDetector(
                      onTap: _pickMedia,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              // Check priority: 1. Local selection 2. Server URL 3. Initial letter
                              backgroundImage: _selectedMedia.isNotEmpty
                                  ? FileImage(File(_selectedMedia.first.path))
                                  : (authState.authEntity?.profilePicture !=
                                                null // Adjust 'image' based on your user entity
                                            ? NetworkImage(
                                              '$_baseUrl${
                                                authState
                                                    .authEntity!
                                                    .profilePicture!}'
                                              )
                                            : null)
                                        as ImageProvider?,
                              child:
                                  (_selectedMedia.isEmpty &&
                                      authState.authEntity?.profilePicture ==
                                          null)
                                  ? Icon(Icons.person)
                                  : (authState.status ==
                                        AuthStatus
                                            .loading) // Show loader while uploading
                                  ? const CircularProgressIndicator()
                                  : null,
                            ),
                          ),
                          // The "+" Add Button overlay
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons
                                    .add_a_photo, // Changed to photo icon for better UX
                                size: 20,
                                color: Color(0xff6A5AE0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    Text(
                      authState.authEntity?.username ??
                          "John Doe", // Bind to real name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      authState.authEntity?.email ??
                          "john.doe@email.com", // Bind to real email
                      style: const TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // MENU
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: const [
                    _MenuItem(
                      icon: Icons.person_outline,
                      title: "Edit Profile",
                    ),
                    SizedBox(height: 12, width: 20),

                    _MenuItem(
                      icon: Icons.logout,
                      title: "Logout",
                      isDestructive: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : AppColors.authPrimary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
