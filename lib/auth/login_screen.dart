import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart'; // arahkan ke halaman home

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void _login() {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    // Simulasi sukses login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text("Welcome Back",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 4),
              const Text("Hello there, sign in to continue"),
              const SizedBox(height: 48),

              // Icon tengah
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEAE0FF),
                  ),
                  child: const Icon(Icons.lock, size: 64, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 48),

              // Username
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.fingerprint),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),

              // Forgot password
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot your password?", style: TextStyle(color: Colors.deepPurple)),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFilled ? _login : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    disabledBackgroundColor: Colors.deepPurple.shade100,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
