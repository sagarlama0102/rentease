import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rentease/screens/dashboard_screen.dart';
import 'package:rentease/screens/signup_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fromKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/loginimage.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Log',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'In',
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
              Form(
                key: _fromKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 78, 78, 78),
                        ),
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your Email",
                          suffixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xff142725),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: _validateEmail,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Color.fromARGB(255, 78, 78, 78)),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color.fromARGB(255, 78, 78, 78),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff142725),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: _validatePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Color(0xff142725),
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login"),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 28),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                    TextSpan(
                      text: "Sign Up",
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
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
