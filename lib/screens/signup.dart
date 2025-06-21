import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart'; // Import homepage

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Find Magic Between the Lines",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Text(
              "Sign up!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildTextField("Email Address", _emailController),
            _buildPasswordField("Password", _passwordController, false),
            _buildPasswordField("Password Confirmation", _confirmPasswordController, true),
            if (_errorMessage != null) _buildErrorMessage(_errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB29A77),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _registerUser,
              child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Already have an account? Login.",
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isConfirm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(
              isConfirm
                  ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                  : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                } else {
                  _isPasswordVisible = !_isPasswordVisible;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "ERROR: Passwords do not match!";
      });
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'The email address is not valid.';
        } else {
          _errorMessage = 'Registration failed: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }
}
