import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure this import matches your file structure

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Sign Up With Klara Café L’D',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thank You for using our service',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Coffee Image Placeholder
                const Icon(Icons.coffee_maker_outlined, size: 100, color: Color(0xFF6F4E37)),

                const SizedBox(height: 20),

                // Main Signup Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE7),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(Icons.person_outline, 'Enter Name'),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.email_outlined, 'Enter Email'),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.lock_outline, 'Enter password', isPassword: true),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.phone_outlined, 'Enter Phone Number'),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password', style: TextStyle(color: Colors.black87, fontSize: 12)),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCCCCCC),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // NAVIGATION TO LOGIN
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Don't have an account ? ",
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                            children: [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.black26)),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Or')),
                          Expanded(child: Divider(color: Colors.black26)),
                        ],
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F4E37),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          icon: const Icon(Icons.g_mobiledata, size: 30),
                          label: const Text('Google'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF8D6E63), width: 0.5),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.black87, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}