import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_prov.dart';
import 'login.dart';

class Register extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  Register({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                _buildRegisterForm(context, authProvider),
                const SizedBox(height: 20),
                _buildLoginPrompt(context),
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
      child: Icon(Icons.person_add, color: Colors.blue, size: 80),
      radius: 70,
    );
  }

  Widget _buildTitle() {
    return Column(
      children: const [
        Text(
          "Create Account",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBox(height: 10),
        Text("Please fill in the details",
            style: TextStyle(color: Colors.white70, fontSize: 18)),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context, AuthProvider authProvider) {
    return Column(
      children: [
        _buildTextField(usernameController, "Username", Icons.person),
        const SizedBox(height: 20),
        _buildTextField(emailController, "Email", Icons.email_outlined),
        const SizedBox(height: 20),
        _buildTextField(passwordController, "Password", Icons.lock,
            obscureText: true),
        const SizedBox(height: 20),
        _buildTextField(
            confirmPasswordController, "Confirm Password", Icons.lock,
            obscureText: true),
        const SizedBox(height: 10),
        _buildRegisterButton(context, authProvider),
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
              BorderSide(color: const Color.fromRGBO(213, 0, 0, 1)), // Outline color set to black
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black), // Border color when focused
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: () async {
        if (usernameController.text.isEmpty ||
            emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            confirmPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')),
          );
        } else if (passwordController.text != confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
        } else {
          bool isRegistered = await authProvider.registerUser(
            usernameController.text,
            emailController.text,
            passwordController.text,
          );
          if (isRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Success')),
            );
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Username already taken')),
            );
          }
        }
      },
      child: const Text(
        "Register",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white // Always white text
            ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(400, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blue.shade700, // Button background color
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login())),
          child: const Text(
            "Login!",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
