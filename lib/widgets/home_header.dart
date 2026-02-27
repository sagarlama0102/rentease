import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/app/theme/app_colors.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:rentease/app/theme/theme_extensions.dart';
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    final String userName = user?.username ?? "User";
    final String userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : "U";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Welcome back,",
                style: TextStyle(fontSize: 16, color: context.textSecondary,),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style:  TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ),

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
                ? NetworkImage(Uri.parse(ApiEndpoints.baseUrlOnly)
              .resolve(user!.profilePicture!)
              .toString(),)
                : null,
            child: user?.profilePicture == null
                ? Text(
                    userInitial,
                    style: TextStyle(
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