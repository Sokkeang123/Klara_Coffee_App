import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Matching the names from your image
  final TextEditingController nameController = TextEditingController(text: "Ning Ning");
  final TextEditingController emailController = TextEditingController(text: "ningning@gmail.com");
  final TextEditingController phoneController = TextEditingController(text: "048264721");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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

                // Main Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EDE4), // Soft beige background
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
                      // Profile Header Info
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage('https://placeholder.com/150'), // Replace with your asset
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Ning Ning", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("ningning@gmail.com", style: TextStyle(color: Colors.black54)),
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

                      // Input Fields
                      _buildTextField(Icons.person_outline, nameController),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.mail_outline, emailController),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.phone_outlined, phoneController),

                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Updated successfully !",
                          style: TextStyle(color: Color(0xFF5CCB8A), fontWeight: FontWeight.bold),
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Helper to build the styled text fields
  Widget _buildTextField(IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8D6E63).withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black87),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  // Bottom Navigation Bar matching the image
  Widget _buildBottomNav() {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFFEBD5B9), // Peach/Tan color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, "Home"),
          _navItem(Icons.menu_book_outlined, "Menu"),
          _navItem(Icons.favorite_outline, "Favorite"),
          _navItem(Icons.shopping_cart_outlined, "Cart"),
          _navItem(Icons.account_circle, "Profile", isActive: true),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: isActive ? Colors.brown : Colors.brown[700]),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.brown[900])),
      ],
    );
  }
}