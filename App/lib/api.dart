// lib/api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // 공통 API URL 설정
  static const String baseUrl = "http://172.30.1.20:8080/api/users/register";

  // 로그인 API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;  // 성공 시 반환
      } else {
        throw Exception('로그인 실패');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 코드 등록하기 api
  static Future<String> registerCode(String username, String code) async {
    // URL 설정
    final url = Uri.parse('$baseUrl/registerCode');

    // POST 요청 보낼 데이터
    final Map<String, String> data = {
      'username': username,
      'code': code,
    };

    try {
      // 서버에 POST 요청 보내기
      final response = await http.post(url, body: data);

      // 서버 응답 처리
      if (response.statusCode == 200) {
        return 'Code registered successfully';
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      // 예외 처리
      return 'Failed to connect to the server: $e';
    }
  }


}