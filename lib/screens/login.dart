import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart'; // Make sure this file exists and has a HomePage widget

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
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
              "Welcome Back!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildTextField("Email Address", _emailController),
            _buildPasswordField("Password", _passwordController),
            if (_errorMessage != null) _buildErrorMessage(_errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB29A77),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _handleLogin,
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Don't have an account? Sign up.",
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Invalid email format.';
        } else {
          _errorMessage = 'Login failed: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
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

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
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
}
