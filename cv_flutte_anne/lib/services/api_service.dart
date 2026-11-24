import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Adaptez selon votre cible :
  // - Émulateur Android : http://10.0.2.2/api-test/public
  // - Web / Windows / iOS sim : http://localhost/api-test/public
  // - Téléphone physique : http://<IP_DE_VOTRE_PC>/api-test/public
  static const String baseUrl = 'http://10.0.2.2/api-test/public';
  static const String _userKey = 'logged_in_user';

  static Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // --- Authentification ---

  static  Future<Map<String,dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/accounts/login');
    final response = await http.post(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && body['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(body['data']));
      return body;
    }

    throw Exception(body['message'] ?? 'Erreur de connexion (${response.statusCode})');
  }

  static Future<Map<String,dynamic>> register({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/accounts/register');
    final response = await http.post(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        body['success'] == true) {
      return body;
    }

    throw Exception(body['message'] ?? 'Erreur d\'inscription (${response.statusCode})');
  }

  static Future<Map<String,dynamic>?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // --- CRUD Famille Membres ---

  static Future<List<dynamic>> getMembres() async {
    final uri = Uri.parse('$baseUrl/famille-membres');
    final response = await http.get(uri, headers: _jsonHeaders);
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && body['success'] == true) {
      final data = body['data'];
      if (data is List) return data;
      if (data is Map && data['items'] is List) return data['items'] as List;
      return [];
    }

    throw Exception(body['message'] ?? 'Impossible de charger les membres');
  }

  static Future<Map<String,dynamic>>createMembre({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance, // format AAAA-MM-JJ
    required String parente,
  }) async {
    final uri = Uri.parse('$baseUrl/famille-membres');
    final response = await http.post(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        body['success'] == true) {
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception(body['message'] ?? 'Erreur lors de la création');
  }

  static Future<Map<String,dynamic>> updateMembre({
    required int id,
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance, // format AAAA-MM-JJ
    required String parente,
  }) async {
    final uri = Uri.parse('$baseUrl/famille-membres/$id');
    final response = await http.put(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception(body['message'] ?? 'Erreur lors de la modification');
  }

  static Future<void> deleteMembre(int id) async {
    final uri = Uri.parse('$baseUrl/famille-membres/$id');
    final response = await http.delete(uri, headers: _jsonHeaders);
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && body['success'] == true) {
      return;
    }

    throw Exception(body['message'] ?? 'Erreur lors de la suppression');
  }
}

