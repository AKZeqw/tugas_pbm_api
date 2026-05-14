import 'package:flutter/material.dart';
import 'dart:math';
import '../services/api_service.dart';
import '../utils/custom_snackbar.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _githubController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _handleSubmit() async {
    final name = _nameController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    final desc = _descController.text.trim();
    final github = _githubController.text.trim();

    if (name.isEmpty || price <= 0 || github.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Lengkapi data produk dan URL GitHub!',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    bool success = await _apiService.submitTask(name, price, desc, github);
    setState(() => _isLoading = false);

    if (success && mounted) {
      CustomSnackBar.show(
        context,
        message: 'Mission Complete! Tugas berhasil terkirim.',
        isError: false,
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } else if (mounted) {
      CustomSnackBar.show(
        context, 
        message: 'Gagal mengirim tugas.', 
        isError: true
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0C29), Color(0xFF000000)],
              ),
            ),
          ),
          const StarFieldSubmit(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'FINAL SUBMISSION',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.rocket_launch_rounded, color: Colors.deepPurpleAccent, size: 50),
                              SizedBox(height: 16),
                              Text(
                                'Ready for Launch?',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Pastikan link GitHub dan data produk sudah benar.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white54, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildInputField(
                          controller: _nameController,
                          label: 'Product Name',
                          icon: Icons.shopping_bag_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _priceController,
                          label: 'Price',
                          icon: Icons.payments_outlined,
                          isNumber: true,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _descController,
                          label: 'Description',
                          icon: Icons.description_outlined,
                          isLongText: true,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _githubController,
                          label: 'GitHub Repo URL',
                          icon: Icons.link_rounded,
                          hint: 'https://github.com/user/repo',
                        ),
                        const SizedBox(height: 48),
                        // TOMBOL SUBMIT: Disesuaikan dengan gaya Login
                        SizedBox(
                          height: 56, // Sesuai tinggi tombol Login
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent, // Warna ungu sesuai Login
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16), // Radius sudut sesuai tema Login
                              ),
                              elevation: 4,
                            ),
                            onPressed: _isLoading ? null : _handleSubmit,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                  )
                                : const Text(
                                    'SUBMIT TASK',
                                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    bool isLongText = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: isLongText ? 3 : 1,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        labelStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent, size: 22),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _githubController.dispose();
    super.dispose();
  }
}

class StarFieldSubmit extends StatelessWidget {
  const StarFieldSubmit({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: StarPainterSubmit());
  }
}

class StarPainterSubmit extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(77);
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 120; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double radius = random.nextDouble() * 1.2;
      paint.color = Colors.white.withOpacity(random.nextDouble() * 0.4);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}