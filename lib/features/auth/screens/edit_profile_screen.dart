import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/storage/user_storage.dart';
import '../data/services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService _profileService = ProfileService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;

  // ✅ ADD: track changes
  bool _hasChanges = false;
  bool _isLoadingUser = false;

  // ✅ ADD: keep original values to compare
  String _originalName = "";
  String _originalEmail = "";
  String _originalPhone = "";

  @override
  void initState() {
    super.initState();
    _listenChanges(); // ✅ ADD
    _loadUser();
  }

  void _listenChanges() {
    void onChanged() {
      if (_isLoadingUser) return;

      final changed =
          nameController.text.trim() != _originalName ||
          emailController.text.trim() != _originalEmail ||
          phoneController.text.trim() != _originalPhone ||
          passwordController.text.trim().isNotEmpty;

      if (changed != _hasChanges) {
        setState(() => _hasChanges = changed);
      } else {
        // still update header name/email on typing
        setState(() {});
      }
    }

    nameController.addListener(onChanged);
    emailController.addListener(onChanged);
    phoneController.addListener(onChanged);
    passwordController.addListener(onChanged);
  }

  Future<void> _loadUser() async {
    _isLoadingUser = true;

    final user = await UserStorage.getUser();
    if (user != null) {
      final n = (user["name"] ?? "").toString();
      final e = (user["email"] ?? "").toString();
      final p = (user["phone"] ?? "").toString();

      _originalName = n;
      _originalEmail = e;
      _originalPhone = p;

      setState(() {
        nameController.text = n;
        emailController.text = e;
        phoneController.text = p;
        _hasChanges = false;
      });
    }

    _isLoadingUser = false;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // If nothing changed, do nothing
    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes detected.")),
      );
      return;
    }

    // ✅ Confirm before updating
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Update"),
        content: const Text("Do you want to update your profile information?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Update"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loading = true);

    try {
      await _profileService.updateProfile(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text.isEmpty ? null : passwordController.text,
      );

      if (!mounted) return;

      // ✅ update originals after success
      _originalName = nameController.text.trim();
      _originalEmail = emailController.text.trim();
      _originalPhone = phoneController.text.trim();

      passwordController.clear();

      setState(() => _hasChanges = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully ✅")),
      );
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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "Klara Kafé L’D",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EDE4),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameController.text.isEmpty ? "—" : nameController.text,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                emailController.text.isEmpty ? "—" : emailController.text,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Account setting",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(Icons.person_outline, nameController),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.mail_outline, emailController),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.phone_outlined, phoneController),

                      const SizedBox(height: 15),
                      _buildTextField(Icons.lock_outline, passwordController, isPassword: true),

                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8D6E63).withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black87),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: isPassword ? "*****" : null,
        ),
      ),
    );
  }
}