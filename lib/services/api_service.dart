import '../models/user_data.dart';
import 'database_helper.dart';

class ApiService {
  static final DatabaseHelper _db = DatabaseHelper.instance;

  static Future<bool> login(String email, String password) async {
    try {
      final user = await _db.getUser(email, password);
      return user != null;
    } catch (e) {
      print('로그인 중 오류 발생: $e');
      return false;
    }
  }

  static Future<String> signUp(String name, String email, String password, String licenseKey) async {
    try {
      if (await _db.isEmailExists(email)) {
        return '2';
      }
      
      if (await _db.isLicenseKeyExists(licenseKey)) {
        return '3';
      }

      final success = await _db.insertUser(User(
        email: email,
        password: password,
        name: name,
        licenseKey: licenseKey
      ));

      return success ? '1' : '0';
    } catch (e) {
      print('회원가입 중 오류 발생: $e');
      return '0';
    }
  }

  static Future<User?> loginWithUser(String email, String password) async {
    try {
      return await _db.getUser(email, password);
    } catch (e) {
      print('로그인 중 오류 발생: $e');
      return null;
    }
  }
}