import '../models/patient_data.dart';
import 'database_helper.dart';

class PatientService {
  static final DatabaseHelper _db = DatabaseHelper.instance;

  static Future<List<Patient>> loadPatients(String licenseKey) async {
    return await _db.getPatientsByLicenseKey(licenseKey);
  }

  static Future<bool> addPatient(Patient patient, String licenseKey) async {
    return await _db.insertPatient(patient, licenseKey);
  }

  static Future<bool> deletePatient(String patientId, String licenseKey) async {
    return await _db.deletePatient(patientId, licenseKey);
  }

  static Future<String> changePassword(String email, String oldPassword, String newPassword) async {
    try {
      final success = await DatabaseHelper.instance.updatePassword(email, oldPassword, newPassword);
      if (success) {
        return '비밀번호가 성공적으로 변경되었습니다.';
      } else {
        return '현재 비밀번호가 일치하지 않습니다.';
      }
    } catch (e) {
      return '비밀번호 변경 중 오류가 발생했습니다.';
    }
  }
}