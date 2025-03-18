//SharedPreferences 관리 함수
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // 로그인 할 때 미리 한번 지우고 저장 시작
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // 모든 데이터 삭제
  }

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

  // 카테고리 정보 저장
  static Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    final prefs = await SharedPreferences.getInstance();

    // 카테고리 ID와 이름을 저장 (카테고리 ID를 Key로 하고, 이름을 Value로 저장)
    for (var category in categories) {
      prefs.setString(category['category_id'].toString(), category['category_name']);
    }
  }

  // 카테고리 이름으로 ID 찾기
  static Future<int?> getCategoryIdByName(String categoryName) async {
    final prefs = await SharedPreferences.getInstance();

    // 모든 키를 가져와서 카테고리 이름에 맞는 ID를 찾기
    final keys = prefs.getKeys();
    for (var key in keys) {
      String? categoryNameStored = prefs.getString(key);
      if (categoryNameStored == categoryName) {
        return int.tryParse(key);  // 카테고리 ID를 String에서 int로 변환하여 반환
      }
    }
    return null;  // 카테고리 이름을 찾을 수 없는 경우 null 반환
  }

  // 공유변수에 저장된 모든 카테고리 이름만 불러오기
  static Future<List<String>> getAllCategoryNames() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List<String> categoryNames = [];

    for (var key in keys) {
      // userName과 registerId는 제외하고 처리
      if (key != 'userName' && key != 'registerId') {
        String? categoryName = prefs.getString(key);
        if (categoryName != null) {
          categoryNames.add(categoryName);  // 카테고리 이름만 추가
        }
      }
    }
    print("공유변수 관리 함수");
    print(categoryNames);

    return categoryNames;
  }

}
