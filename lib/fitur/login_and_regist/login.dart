import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:applicationenglish/Home.dart';
import 'auth_prov.dart';
import 'register.dart';

class Login extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Memuat informasi login yang tersimpan di SharedPreferences
    authProvider.loadRegisterInfo();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: _buildGradientBackground(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleAvatar(),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 30),
                _buildLoginForm(context, authProvider),
                const SizedBox(height: 20),
                _buildRegisterPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade800, Colors.blue.shade200],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildCircleAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(Icons.person, color: Colors.blue, size: 80),
      radius: 70,
    );
  }

  Widget _buildTitle() {
    return Column(
      children: const [
        Text(
          "Welcome Back!",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBox(height: 10),
        Text("Please login to your account",
            style: TextStyle(color: Colors.white70, fontSize: 18)),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthProvider authProvider) {
    return Column(
      children: [
        _buildTextField(usernameController, "Username", Icons.person),
        const SizedBox(height: 20),
        _buildTextField(passwordController, "Password", Icons.lock,
            obscureText: true),
        const SizedBox(height: 10),
        _buildLoginButton(context, authProvider),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // Always black for text content
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black), // Always black for labels
        hintStyle: TextStyle(color: Colors.black), // Always black for hints
        filled: true,
        fillColor: Colors.transparent, // Set background color to white
        prefixIcon: Icon(icon, color: Colors.black), // Icon color set to black
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.black), // Outline color set to black
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromRGBO(213, 0, 0, 1)), // Border color when focused
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: () {
        if (usernameController.text.isEmpty ||
            passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in both fields')),
          );
        } else if (authProvider.validateCredentials(
            usernameController.text, passwordController.text)) {
          authProvider.saveLoginStatus(true);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      },
      child: const Text(
        "Login",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white), // Always white text
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(400, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blue.shade700, // Button background color
      ),
    );
  }

  Widget _buildRegisterPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Register())),
          child: const Text(
            "Register!",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
