import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/app_routes.dart';
// import '../data/service/auth_service.dart';
import '../data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ✅ must be initialized (not nullable)
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  final AuthService _auth = AuthService();
  bool _loading = false;

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _auth.login(email: email, password: password);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign In With Klara Café L\'D',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text('Thank You for using our service',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 20),

              Image.asset(
                'assets/images/login_image.png',
                height: 180,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.coffee, size: 100, color: Colors.brown),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EEE7),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ pass controller
                    _buildTextField(
                      controller: _emailCtrl,
                      hintText: 'Enter Email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _passCtrl,
                      hintText: 'Enter password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCCCCCC),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: _loading ? null : _login, // ✅ call API
                        child: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                        child: const Text.rich(
                          TextSpan(
                            text: "Don't have an account ? ",
                            style: TextStyle(fontSize: 13),
                            children: [
                              TextSpan(text: 'Sign up', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.black, thickness: 1)),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Or')),
                        Expanded(child: Divider(color: Colors.black, thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6F4E37),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.home);
                        },
                        icon: const Icon(Icons.g_mobiledata, size: 30),
                        label: const Text('Google'),
                      ),
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

  // ✅ add controller param (UI same)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF8D6E63), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.black87),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}