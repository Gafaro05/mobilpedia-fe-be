import 'api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  
  static String get baseUrl => ApiConfig.baseUrl;

  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  String? _token;
  int? _userId;
  String? _userName;

  String? get token => _token;
  int? get userId => _userId;
  String? get userName => _userName;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> _headers({bool withAuth = false}) {
    final h = <String, String>{
      'Content-Type': 'application/json',
    };
    if (withAuth && _token != null) {
      h['Authorization'] = 'Bearer $_token';
    }
    return h;
  }

  // ========== AUTH ==========

  Future<Map<String, dynamic>?> getProfile() async {
    final url = Uri.parse('$baseUrl/api/auth/profile');
    final res = await http.get(url, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> updateProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/profile');
    final res = await http.put(
      url,
      headers: _headers(withAuth: true),
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'address': address,
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _userName = data['user']?['name'] as String?;
      return true;
    }
    return false;
  }

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
    }
    return false;
  }

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

    return res.statusCode == 201;
  }

  // ========== BRAND ==========

  Future<List<dynamic>> getBrands() async {
    final url = Uri.parse('$baseUrl/api/brands');
    final res = await http.get(url, headers: _headers());
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Gagal mengambil brand');
  }

  // ========== CARS ==========
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

    final uri = Uri.parse('$baseUrl/api/cars/brand/$brandId')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final res = await http.get(
      uri,
      headers: _headers(),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil mobil brand $brandId');
    }
  }

  Future<Map<String, dynamic>?> getCarDetail(int carId) async {
    final url = Uri.parse('$baseUrl/api/cars/$carId');
    final res = await http.get(url, headers: _headers());
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

 

  // ========== FAVORITES ==========

  Future<List<dynamic>> getFavorites() async {
    final url = Uri.parse('$baseUrl/api/favorites');
    final res = await http.get(url, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Gagal mengambil favorite');
  }

  Future<bool> addFavorite(int carId) async {
    final url = Uri.parse('$baseUrl/api/favorites');
    final res = await http.post(
      url,
      headers: _headers(withAuth: true),
      body: jsonEncode({'carId': carId}),
    );
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> removeFavorite(int carId) async {
    final url = Uri.parse('$baseUrl/api/favorites/$carId');
    final res = await http.delete(url, headers: _headers(withAuth: true));
    return res.statusCode == 200;
  }

  // ========== NOTIFICATIONS ==========

    Future<List<dynamic>> getNotifications({int? brandId}) async {
    final queryParams = <String, String>{};
    if (brandId != null) {
      queryParams['brandId'] = brandId.toString();
    }

    final uri = Uri.parse('$baseUrl/api/notifications')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final res = await http.get(uri, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil notifikasi');
    }
  }


  // ========== ADS ==========

  Future<List<dynamic>> getAds() async  {
    final url = Uri.parse('$baseUrl/api/ads');
    final res = await http.get(url, headers: _headers());
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Gagal mengambil iklan');
  }





  
}
