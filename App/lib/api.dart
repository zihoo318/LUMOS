// lib/api.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'SharedPreferencesManager.dart';

class Api {
  // 공통 API URL 설정
  static const String baseUrl = "http://192.168.45.124:8080/api";

  // 로그인 API
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'), // 로그인 엔드포인트
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 로그인 성공 시 SharedPreferences에 저장
        await SharedPreferencesManager.saveUserName(username);

        return {'success': true, 'data': data}; // 성공 시 응답 데이터 반환
      } else {
        return {'success': false, 'error': response.body}; // 실패 시 에러 메시지 반환
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'}; // 예외 발생 시 처리
    }
  }

  // 회원가입 API
  static Future<Map<String, dynamic>> signUp({
    required String username,
    required String password,
    required String email,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email,
          "role": role,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        String message = utf8.decode(response.bodyBytes);
        return {'success': false, 'error': message};
      }
    } catch (e) {
      return {'success': false, 'error': '네트워크 오류가 발생했습니다. 다시 시도해주세요.'};
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
        Uri.parse('$baseUrl/registerCode?username=$userName&code=$code'),
        headers: {'Content-Type': 'application/json'},
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

      // URL 파라미터로 값 전달
      final response = await http.post(
        Uri.parse('$baseUrl/setCodeName?registerId=$registerId&codeName=$codeName'),
        headers: {'Content-Type': 'application/json'},
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
  Future<Map<String, dynamic>> createCategory(String categoryName) async {
    try {
      // SharedPreferences에서 userName을 가져옴
      String? userName = await SharedPreferencesManager.getUserName();

      if (userName == null) {
        throw Exception('User name is not found. 로그인을 먼저 해주세요');
      }

      // 카테고리 생성 API 호출
      final response = await http.post(
        Uri.parse('$baseUrl/category/create'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': userName,
          'categoryName': categoryName,
        },
      );

      if (response.statusCode == 200) {
        // 카테고리 생성 성공 후, 새로운 카테고리 목록을 가져와서 SharedPreferences 업데이트
        await getCategoriesByUsername(userName);

        // 성공 메시지 반환
        return {'message': response.body};
      } else {
        // 실패 시 에러 메시지 반환
        return {'error': response.body};
      }
    } catch (e) {
      // 예외 처리
      return {'error': 'Error: $e'};
    }
  }

  // 카테고리 이름 가져오기
  Future<List<Map<String, dynamic>>> getCategoriesByUsername(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/list?username=$username'),
    );

    if (response.statusCode == 200) {
      // 서버에서 받은 응답을 파싱하여 카테고리 정보를 리스트로 변환
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> categories = List<Map<String, dynamic>>.from(data);

      // 카테고리 정보를 SharedPreferences에 저장
      await SharedPreferencesManager.saveCategories(categories);

      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // 카테고리에 코드 연결하기 API
  static Future<Map<String, dynamic>> addCodeToCategory(int categoryId) async {
    try {
      // SharedPreferences에서 userName을 가져옴
      String? userName = await SharedPreferencesManager.getUserName();

      if (userName == null) {
        throw Exception('User name is not found. 로그인을 먼저 해주세요');
      }

      // SharedPreferences에서 registerId 불러오기
      String? registerId = await SharedPreferencesManager.getRegisterId();

      if (registerId == null) {
        throw Exception('Register ID is not found. 등록 정보를 먼저 확인해주세요');
      }

      // API 호출
      final response = await http.post(
        Uri.parse('$baseUrl/category/addCodeToCategory'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'categoryId': categoryId.toString(),
          'registerId': registerId,  // registerId는 SharedPreferences에서 불러온 값
        },
      );

      if (response.statusCode == 200) {
        // 성공 시 응답 본문 반환
        return {'message': response.body};
      } else {
        // 실패 시 서버에서 전달한 에러 메시지 반환
        return {'error': response.body};
      }
    } catch (e) {
      // 예외 발생 시 처리
      return {'error': 'Error: $e'};
    }
  }

  // 카테고리 별 전체 조회
  Future<Map<String, List<Map<String, String>>>> fetchUserCategoryCodes() async {
    // SharedPreferences에서 userName을 가져옴
    String? username = await SharedPreferencesManager.getUserName();

    // 사용자 이름이 없다면 예외 처리
    if (username == null || username.isEmpty) {
      throw Exception('Username not found');
    }

    // 서버 URL (Spring Boot API 엔드포인트)
    final String url = '$baseUrl/category/getUserCategoryCodes?username=$username';

    try {
      // GET 요청 보내기
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 요청이 성공하면 JSON 파싱
        final Map<String, dynamic> data = json.decode(response.body);

        // 파싱된 데이터를 Map 형태로 반환
        return data.map((key, value) {
          return MapEntry(key, List<Map<String, String>>.from(value.map((e) => Map<String, String>.from(e))));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  // 날짜별 파일 목록 조회 API 추가
  static Future<List<String>> getFilesByDate(String date, String userName) async {
    print("API 요청 시작 - getFilesByDate: $date");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/calendar/files?date=$date&user=$userName'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> fileList = json.decode(response.body);
        return List<String>.from(fileList); // 파일 리스트 변환 후 반환
      } else {
        return [];
      }
    } catch (e) {
      print("파일 불러오기 실패: $e");
      return [];
    }
  }
}