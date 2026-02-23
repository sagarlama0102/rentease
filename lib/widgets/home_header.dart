import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/app/theme/app_colors.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Listen to the same Auth State as the Profile Page
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;
    final String baseUrl = "http://172.26.0.73:4000";

    // Fallback if name is empty
    final String userName = user?.username ?? "User";
    final String userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : "U";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Aligned for better look
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back,",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22, // Increased size for name
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
        // 2. Dynamic Profile Picture / Initial
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.authPrimary.withOpacity(0.2),
            backgroundImage: user?.profilePicture != null
                ? NetworkImage('$baseUrl${user!.profilePicture}')
                : null,
            child: user?.profilePicture == null
                ? Text(
                    userInitial,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.authPrimary,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}