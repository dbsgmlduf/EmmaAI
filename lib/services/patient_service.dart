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
}