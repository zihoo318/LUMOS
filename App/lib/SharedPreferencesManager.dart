//SharedPreferences 관리 함수
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // registerId 저장
  static Future<void> saveRegisterId(String registerId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('registerId', registerId);  // SharedPreferences에 registerId 저장
  }

  // registerId 불러오기
  static Future<String?> getRegisterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('registerId');  // 저장된 registerId 반환
  }

  // userName 저장
  static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);  // SharedPreferences에 userName 저장
  }

  // userName 불러오기
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');  // 저장된 userName 반환
  }
}
