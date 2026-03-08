import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentease/app/routes/app_routes.dart';
import 'package:rentease/app/theme/app_colors.dart';
import 'package:rentease/app/theme/theme_extensions.dart';
import 'package:rentease/app/theme/theme_provider.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/core/utils/snackbar_utils.dart';
import 'package:rentease/features/auth/presentation/pages/login_page.dart';
import 'package:rentease/features/auth/presentation/state/auth_state.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:rentease/features/dashboard/presentation/widgets/privacy_blur_wrapper.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  // --- Permission & Logic Helpers ---
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
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
          "Please enable access in settings to update your profile photo.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImageSelection(XFile? file) async {
    if (file != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(file);
      });
      await ref
          .read(authViewModelProvider.notifier)
          .uploadPhoto(File(file.path));
    }
  }

  Future<void> _pickFromCamera() async {
    if (await _requestPermission(Permission.camera)) {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      _handleImageSelection(photo);
    }
  }

  Future<void> _pickFromGallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    _handleImageSelection(image);
  }

  void _pickMedia() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.created) {
        SnackbarUtils.showSuccess(context, "Profile updated successfully");
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return PrivacyBlurWrapper(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // --- HEADER SECTION ---
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Curved Primary Background
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors
                          .authPrimary, // Stays green/primary in both modes
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Profile Settings",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  // Avatar Positioned over the edge
                  Positioned(top: 140, child: _buildModernAvatar(authState)),
                ],
              ),
      
              const SizedBox(height: 70), // Gap for the overlapping avatar
              // --- USER INFO ---
              Text(
                authState.authEntity?.username ?? "User Name",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                authState.authEntity?.email ?? "email@example.com",
                style: TextStyle(
                  fontSize: 14,
                  color: context.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
      
              const SizedBox(height: 40),
      
              // --- MENU SECTION ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.textSecondary.withOpacity(0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ModernMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: "Edit Profile",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _ModernMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: "Notifications",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _ModernMenuItem(
                      icon: Icons.security_rounded,
                      title: "Security",
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    _ModernMenuItem(
                      icon: Icons.logout_rounded,
                      title: "Logout",
                      isDestructive: true,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAvatar(AuthState authState) {
    return GestureDetector(
      onTap: _pickMedia,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: context.surfaceColor,
              backgroundImage: _selectedMedia.isNotEmpty
                  ? FileImage(File(_selectedMedia.first.path))
                  : (authState.authEntity?.profilePicture != null
                            ? NetworkImage(
                                '${ApiEndpoints.baseUrlOnly}${authState.authEntity!.profilePicture!}',
                              )
                            : null)
                        as ImageProvider?,
              child:
                  (authState.authEntity?.profilePicture == null &&
                      _selectedMedia.isEmpty)
                  ? Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: context.textSecondary,
                    )
                  : (authState.status == AuthStatus.loading
                        ? const CircularProgressIndicator()
                        : null),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: AppColors.authPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.backgroundColor, width: 3),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        backgroundColor: context.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to end your session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dContext);
              await ref.read(authViewModelProvider.notifier).logout();
              if (mounted)
                AppRoutes.pushAndRemoveUntil(context, const LoginPage());
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ModernMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ModernMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.redAccent : context.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.borderColor.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.authPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.redAccent : AppColors.authPrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.textSecondary.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
