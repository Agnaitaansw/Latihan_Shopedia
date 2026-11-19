
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';
import '../services/cart_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Mengambil email dari SharedPreferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      email = prefs.getString('email') ?? 'Email tidak ditemukan';
    });
  }

  // Proses logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Menghapus status login
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');

    if (!mounted) return;

    // Kembali ke halaman Login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            const SizedBox(height: 30),

            // Foto profil
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Email pengguna
            const Text(
              'Email Pengguna',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              email,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Jumlah produk dalam keranjang
            ValueListenableBuilder<Box>(
              valueListenable:
                  Hive.box('cartBox').listenable(),

              builder: (context, box, child) {
                final cartCount = CartService.getCartCount();

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.shopping_cart,
                      color: Colors.blue,
                      size: 30,
                    ),

                    title: const Text(
                      'Jumlah Produk di Keranjang',
                    ),

                    trailing: Text(
                      '$cartCount Produk',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            // Tombol Logout
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: _logout,

                icon: const Icon(Icons.logout),

                label: const Text('Logout'),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
