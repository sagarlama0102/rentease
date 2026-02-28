import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/app/theme/app_colors.dart';
import 'package:rentease/app/theme/theme_extensions.dart';
import 'package:rentease/core/utils/snackbar_utils.dart';
import 'package:rentease/features/auth/presentation/state/auth_state.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authViewModelProvider.notifier)
          .register(
            firstName: _fnameController.text,
            lastName: _lnameController.text,
            email: _emailController.text,
            username: _emailController.text.trim().split('@').first,
            password: _passwordController.text,
            phoneNumber: _phoneController.text,
            confirmPassword: _confirmPasswordController.text,
          );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Registration failed",
        );
      } else if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(
          context,
          next.errorMessage ?? "Registration Success",
        );
      }
    });

    return Scaffold(
  resizeToAvoidBottomInset: false,
  body: Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/logintwoimage.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.65),
            Colors.black.withOpacity(0.85),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// Logo Title
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Rent',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'Ease',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff99DAB3),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Create your account",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              /// FORM (LOGIC UNCHANGED)
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    /// First & Last Name
                    Row(
                      children: [
                        Expanded(
                          child: _modernInput(
                            controller: _fnameController,
                            label: "First Name",
                            icon: Icons.person_outline_rounded,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _modernInput(
                            controller: _lnameController,
                            label: "Last Name",
                            icon: Icons.person_outline_rounded,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// Email
                    _modernInput(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    /// Phone
                    _modernInput(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone';
                        }
                        if (value.length != 10) {
                          return 'Must be 10 digits';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    /// Password
                    _modernPasswordInput(
                      controller: _passwordController,
                      label: "Password",
                      obscure: _obscurePassword,
                      onToggle: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      validator: (value) =>
                          (value != null && value.length < 6)
                              ? 'Min 6 characters'
                              : null,
                    ),

                    const SizedBox(height: 18),

                    /// Confirm Password
                    _modernPasswordInput(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      obscure: _obscureConfirmPassword,
                      onToggle: () => setState(
                        () => _obscureConfirmPassword =
                            !_obscureConfirmPassword,
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// Sign Up Button
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor:
                        AppColors.authPrimary.withOpacity(0.5),
                  ),
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Create an Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 28),

              /// Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xff99DAB3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }
}
Widget _modernInput({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType? keyboardType,
  int? maxLength,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLength: maxLength,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      counterText: "",
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    validator: validator,
  );
}

Widget _modernPasswordInput({
  required TextEditingController controller,
  required String label,
  required bool obscure,
  required VoidCallback onToggle,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: const Icon(Icons.lock_outline_rounded,
          color: Colors.white70),
      suffixIcon: IconButton(
        icon: Icon(
          obscure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.white70,
        ),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    validator: validator,
  );
}
