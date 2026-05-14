import 'package:flutter/material.dart';
import 'dart:math';
import '../services/api_service.dart';
import '../utils/custom_snackbar.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _handleAddProduct() async {
    final name = _nameController.text.trim();
    final priceStr = _priceController.text.trim();
    final price = int.tryParse(priceStr) ?? 0;
    final desc = _descController.text.trim();

    if (name.isEmpty || priceStr.isEmpty || price <= 0 || desc.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Lengkapi semua data produk!',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    bool success = await _apiService.addProduct(name, price, desc);
    setState(() => _isLoading = false);

    if (success && mounted) {
      CustomSnackBar.show(
        context,
        message: 'Produk berhasil ditambahkan!',
        isError: false,
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context, true);
      });
    } else if (mounted) {
      CustomSnackBar.show(
        context, 
        message: 'Gagal menambahkan produk.', 
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
          const StarFieldAdd(),
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
                        'ADD NEW PRODUCT',
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
                              Icon(Icons.add_business_rounded, color: Colors.deepPurpleAccent, size: 50),
                              SizedBox(height: 16),
                              Text(
                                'New Inventory Item',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tambahkan detail produk baru ke dalam inventory.',
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
                        const SizedBox(height: 48),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            onPressed: _isLoading ? null : _handleAddProduct,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                  )
                                : const Text(
                                    'ADD PRODUCT',
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
    super.dispose();
  }
}

class StarFieldAdd extends StatelessWidget {
  const StarFieldAdd({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: StarPainterAdd());
  }
}

class StarPainterAdd extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(88);
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
