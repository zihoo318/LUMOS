// lib/api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SharedPreferencesManager.dart';

class Api {
  // 공통 API URL 설정
  static const String baseUrl = "http://172.30.1.20:8080/api";

  // 로그인 API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
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
  static Future<Map<String, dynamic>> registerCode(String code) async {
    try {
      // SharedPreferences에서 userName을 가져옴
      String? userName = await SharedPreferencesManager.getUserName();

      if (userName == null) {
        // 만약 userName이 null이면 에러를 반환
        throw Exception('User name is not found. 로그인을 먼저 해주세요');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/registerCode'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': userName,   // SharedPreferences에서 가져온 userName 사용
          'code': code,           // 코드
        }),
      );

      if (response.statusCode == 200) {
        // 성공 시 응답에서 Register ID 추출
        String responseBody = response.body;

        // "Register ID: " 이후의 숫자만 추출
        String registerId = responseBody.split('Register ID: ')[1].trim();

        // registerId를 SharedPreferences에 저장
        await SharedPreferencesManager.saveRegisterId(registerId);

        // 반환값으로 registerId를 포함한 데이터 반환
        return {'registerId': registerId}; // registerId만 반환
      } else {
        // 실패 시 서버에서 전달한 에러 메시지 그대로 반환
        return {'error': response.body};
      }
    } catch (e) {
      // 예외 발생 시 에러 메시지 반환
      return {'error': 'Error: $e'};
    }
  }

  // 별명 등록 API
  static Future<String> setCodeNameForRegister(String codeName) async {
    try {
      // SharedPreferences에서 registerId를 불러옴
      String? registerId = await SharedPreferencesManager.getRegisterId(); // await: 비동기적으로 함수를 호출(앞서 호출된 새로 저장하는 함수가 완료되어야 실행됨)

      if (registerId == null) {
        throw Exception('Register ID is not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/setCodeName'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'registerId': registerId,  // 등록된 코드의 ID (SharedPreferences에서 불러온 값)
          'codeName': codeName,      // 사용자 별명
        }),
      );

      if (response.statusCode == 200) {
        return response.body;  // 성공 시 서버에서 받은 응답 본문 그대로 반환
      } else {
        throw Exception('별명 등록 실패');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 새로운 카테고리 생성 API
  static Future<Map<String, dynamic>> createCategory(String categoryName) async {
    try {
      // SharedPreferences에서 userName을 가져옴
      String? userName = await SharedPreferencesManager.getUserName();

      if (userName == null) {
        throw Exception('User name is not found. 로그인을 먼저 해주세요');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/category/create'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': userName,
          'categoryName': categoryName,
        },
      );

      if (response.statusCode == 200) {
        return {'message': response.body};
      } else {
        return {'error': response.body};
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }



}