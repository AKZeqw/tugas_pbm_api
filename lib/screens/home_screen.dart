import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import 'login_screen.dart';
import 'submit_screen.dart';
import 'add_product_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  // Fungsi untuk logout
  void _logout(BuildContext context) async {
    await _apiService.logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1F),
      // AppBar dengan tombol Logout di pojok kanan atas
      appBar: AppBar(
        title: const Text(
          'INVENTORY',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent),
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'DAFTAR PRODUK',
                    style: TextStyle(color: Colors.white38, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                // Menampilkan daftar produk dari API
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _apiService.getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent));
                      }
                      
                      if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Inventory is empty.", style: TextStyle(color: Colors.white24)),
                        );
                      }

                      final products = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = ProductModel.fromJson(products[index]);
                          return _buildProductCard(product);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tiga Tombol Aksi Horizontal di Bagian Bawah (Style sesuai Login)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomActionButtons(),
          ),
        ],
      ),
    );
  }

  // Widget Card untuk menampilkan nama, harga, dan deskripsi produk
  Widget _buildProductCard(ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.inventory_2_rounded, color: Colors.deepPurpleAccent, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${product.price}",
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Barisan tombol horizontal: TAMBAH, GAME, SUBMIT
  Widget _buildBottomActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [const Color(0xFF0D0B1F), const Color(0xFF0D0B1F).withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          // Tombol Tambah Product
          Expanded(
            child: _buildStyledButton(
              label: 'ADD',
              icon: Icons.add_box_rounded,
              color: const Color(0xFF2C2C2E),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductScreen()),
                ).then((value) {
                  if (value == true) {
                    setState(() {});
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStyledButton(
              label: 'SUBMIT',
              icon: Icons.rocket_launch_rounded,
              color: Colors.deepPurpleAccent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubmitScreen()),
              ).then((_) => setState(() {})),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi pembantu untuk membuat tombol dengan gaya Login/Submit
  Widget _buildStyledButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 56, // Tinggi sama dengan tombol Login
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Radius 16
          padding: EdgeInsets.zero,
          elevation: 4,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }
}