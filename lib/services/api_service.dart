import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'https://task.itprojects.web.id'; // 
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String nim, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login'); // [cite: 61]
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // [cite: 150, 172]
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': nim, // [cite: 64]
          'password': password, // [cite: 64]
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await storage.write(key: 'auth_token', value: data['data']['token']);
        return {'success': true, 'message': 'Login Berhasil'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login Gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }

  Future<List<dynamic>> getProducts() async {
    final url = Uri.parse('$baseUrl/api/products'); // [cite: 110]
    String? token = await storage.read(key: 'auth_token');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // [cite: 4, 149]
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Perbaikan jalur data berdasarkan hasil Postman Anda:
        return responseData['data']['products'] ?? []; 
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> submitTask(String name, int price, String description, String github) async {
    final url = Uri.parse('$baseUrl/api/products/submit'); // [cite: 156]
    String? token = await storage.read(key: 'auth_token');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'github_url': github, // [cite: 162]
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(String name, int price, String description) async {

    final url = Uri.parse('$baseUrl/api/products');
    String? token = await storage.read(key: 'auth_token');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}