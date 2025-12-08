import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service utama untuk komunikasi Flutter <-> Express backend.
class ApiService {
  /// GANTI IP ini sesuai kondisi kamu:
  /// - Emulator Android: http://10.0.2.2:3000
  /// - HP fisik: http://IP_LAPTOP:3000
  static const String baseUrl = 'http://10.0.2.2:3000';

  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  String? _token;
  int? _userId;
  String? _userName;

  String? get token => _token;
  int? get userId => _userId;
  String? get userName => _userName;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> _headers({bool withAuth = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (withAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // =============================
  // AUTH
  // =============================

  /// Register user baru
  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/register');

    final res = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
      }),
    );

    if (res.statusCode == 201) {
      return true;
    } else {
      // Bisa ditambahkan baca pesan error dari backend
      return false;
    }
  }

  /// Login (email atau username)
  Future<bool> login({
    required String emailOrUsername,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    final res = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode({
        'emailOrUsername': emailOrUsername,
        'password': password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      _token = data['token'] as String?;
      _userId = data['user']?['id'] as int?;
      _userName = data['user']?['name'] as String?;

      return _token != null;
    } else {
      return false;
    }
  }

  // =============================
  // BRAND
  // =============================

  /// Ambil semua brand (buat halaman Home)
  Future<List<dynamic>> getBrands() async {
    final url = Uri.parse('$baseUrl/api/brands');
    final res = await http.get(url, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil brand');
    }
  }

  // =============================
  // CARS
  // =============================

  /// Ambil mobil per brandId (buat BrandPage)
  Future<List<dynamic>> getCarsByBrand({
    required int brandId,
    String? series,
    String? bodyType,
  }) async {
    final queryParams = <String, String>{};
    if (series != null && series.isNotEmpty) {
      queryParams['series'] = series;
    }
    if (bodyType != null && bodyType.isNotEmpty) {
      queryParams['bodyType'] = bodyType;
    }

    final url = Uri.parse('$baseUrl/api/cars/brand/$brandId')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final res = await http.get(url, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil mobil brand $brandId');
    }
  }

  /// Detail satu mobil (buat halaman view mobil)
  Future<Map<String, dynamic>> getCarDetail(int carId) async {
    final url = Uri.parse('$baseUrl/api/cars/$carId');
    final res = await http.get(url, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Gagal mengambil detail mobil');
    }
  }

  // =============================
  // FAVORITE
  // =============================

  /// Ambil semua mobil favorite user (halaman Favorite)
  Future<List<dynamic>> getFavorites({int? brandId}) async {
    final queryParams = <String, String>{};
    if (brandId != null) {
      queryParams['brandId'] = brandId.toString();
    }

    final url = Uri.parse('$baseUrl/api/favorites')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final res =
        await http.get(url, headers: _headers(withAuth: true));

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil favorite');
    }
  }

  /// Tambah favorite
  Future<bool> addFavorite(int carId) async {
    final url = Uri.parse('$baseUrl/api/favorites');

    final res = await http.post(
      url,
      headers: _headers(withAuth: true),
      body: jsonEncode({'carId': carId}),
    );

    return res.statusCode == 201 || res.statusCode == 200;
  }

  /// Hapus favorite
  Future<bool> removeFavorite(int carId) async {
    final url = Uri.parse('$baseUrl/api/favorites/$carId');

    final res = await http.delete(
      url,
      headers: _headers(withAuth: true),
    );

    return res.statusCode == 200;
  }

  // =============================
  // NOTIFICATIONS
  // =============================

  Future<List<dynamic>> getNotifications() async {
    final url = Uri.parse('$baseUrl/api/notifications');
    final res = await http.get(url, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil notifikasi');
    }
  }

  // =============================
  // ADS / IKLAN
  // =============================

  Future<List<dynamic>> getAds() async {
    final url = Uri.parse('$baseUrl/api/ads');
    final res = await http.get(url, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil iklan');
    }
  }
}
