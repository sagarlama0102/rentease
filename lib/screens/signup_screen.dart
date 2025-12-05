import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rentease/screens/dashboard_screen.dart';
import 'package:rentease/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String _password = '';
  final TextEditingController _passwordController = TextEditingController();

  
  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Please enter your $fieldName";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number.';
    }
    // Basic phone number validation (at least 7 digits)
    if (!RegExp(r'^\d{7,}$').hasMatch(value)) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please set a password.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != _password) {
      return 'Passwords do not match.';
    }
    return null;
  }

  void _submitSignup() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }

  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logintwoimage.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50), 
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Sign',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'Up',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff99DAB3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                style: const TextStyle(color: Color.fromARGB(255, 78, 78, 78)),
                                decoration: _buildInputDecoration(
                                  labelText: "First Name", 
                                  hintText: "Enter your first name", 
                                  icon: Icons.person
                                ),
                                validator: (value) => _validateName(value, 'first name'),
                              ),
                            ),
                            
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                style: const TextStyle(color: Colors.grey),
                                decoration: _buildInputDecoration(
                                  labelText: "Last Name", 
                                  hintText: "Enter your last name", 
                                  icon: Icons.person_outline
                                ),
                                validator: (value) => _validateName(value, 'last name'),
                              ),
                            ),

                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.grey),
                                decoration: _buildInputDecoration(
                                  labelText: "Email", 
                                  hintText: "Enter your Email", 
                                  icon: Icons.email
                                ),
                                validator: _validateEmail,
                              ),
                            ),
                            
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(color: Colors.grey),
                                decoration: _buildInputDecoration(
                                  labelText: "Phone Number", 
                                  hintText: "Enter your phone number", 
                                  icon: Icons.phone
                                ),
                                validator: _validatePhone,
                              ),
                            ),

                           
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                style: const TextStyle(color: Colors.grey),
                                onChanged: (value) {
                                  
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                decoration: _buildInputDecoration(
                                  labelText: 'Set Password',
                                  hintText: 'Create a password',
                                  icon: Icons.lock, 
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                            ),
                            
                            
                            Padding(
                              
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                              child: TextFormField(
                                obscureText: !_isConfirmPasswordVisible,
                                style: const TextStyle(color: Colors.grey),
                                decoration: _buildInputDecoration(
                                  labelText: 'Confirm Password',
                                  hintText: 'Re-enter your password',
                                  icon: Icons.lock_open,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: _validateConfirmPassword,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: _submitSignup,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: Color(0xff142725),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sign Up"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),

                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 212, 212, 212),
                              ),
                            ),
                            TextSpan(
                              text: "Login",
                              style: const TextStyle(
                                fontSize: 19,
                                color: Color(0xff99DAB3),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                            ),
                            
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),


                      ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 78, 78, 78)),
      hintStyle: const TextStyle(color: Color.fromARGB(255, 78, 78, 78)),
      prefixIcon: Icon(icon, color: Color.fromARGB(255, 78, 78, 78)),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xff142725), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

}
