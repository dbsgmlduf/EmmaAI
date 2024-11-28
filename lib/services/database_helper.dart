import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_data.dart';
import '../models/patient_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stomatitis.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      email TEXT PRIMARY KEY CHECK(length(email) <= 255),
      password TEXT NOT NULL CHECK(length(password) <= 64),
      name TEXT NOT NULL CHECK(length(name) <= 255),
      licenseKey TEXT NOT NULL CHECK(length(licenseKey) <= 255)
    )
  ''');

    await db.execute('''
    CREATE TABLE patients (
      patientId TEXT PRIMARY KEY,
      date TEXT NOT NULL,
      age INTEGER NOT NULL,
      sex TEXT NOT NULL CHECK(sex IN ('Male', 'Female', 'Other')),
      licenseKey TEXT NOT NULL,
      FOREIGN KEY (licenseKey) REFERENCES users (licenseKey)
    )
  ''');

    await db.execute('''
  CREATE TABLE patientchart (
    chartId INTEGER PRIMARY KEY AUTOINCREMENT,
    patientId TEXT NOT NULL,
    originalImage TEXT,
    resultImage TEXT,
    findings TEXT,
    painLevel TEXT,
    note TEXT,
    stomcount TEXT,
    date TEXT NOT NULL,
    stomsize TEXT,
    FOREIGN KEY (patientId) REFERENCES patients (patientId)
  )
''');
  }


  Future<bool> insertUser(User user) async {
    final db = await database;
    try {
      await db.insert('users', user.toJson());
      return true;
    } catch (e) {
      print('사용자 추가 중 오류 발생: $e');
      return false;
    }
  }

  Future<User?> getUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) return null;
    return User.fromJson(maps.first);
  }

  Future<bool> isEmailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<bool> isLicenseKeyExists(String licenseKey) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'licenseKey = ?',
      whereArgs: [licenseKey],
    );
    return result.isNotEmpty;
  }

  Future<List<Patient>> getPatientsByLicenseKey(String licenseKey) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'patients',
      where: 'licenseKey = ?',
      whereArgs: [licenseKey],
    );

    return List.generate(maps.length, (i) => Patient.fromJson(maps[i]));
  }

  Future<bool> insertPatient(Patient patient, String licenseKey) async {
    final db = await database;
    try {
      await db.insert('patients', {
        'patientId': patient.id,
        'date': patient.date,
        'age': patient.age,
        'sex': patient.sex,
        'licenseKey': licenseKey,
      });
      return true;
    } catch (e) {
      print('환자 추가 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> deletePatient(String patientId, String licenseKey) async {
    final db = await database;
    try {
      final rowsDeleted = await db.delete(
        'patients',
        where: 'patientId = ? AND licenseKey = ?',
        whereArgs: [patientId, licenseKey],
      );
      return rowsDeleted > 0;
    } catch (e) {
      print('환자 삭제 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> updatePassword(String email, String oldPassword, String newPassword) async {
    final db = await database;
    try {
      // 먼저 현재 비밀번호가 맞는지 확인
      final user = await getUser(email, oldPassword);
      if (user == null) {
        return false; // 현재 비밀번호가 틀림
      }

      // 비밀번호 업데이트
      final rowsUpdated = await db.update(
        'users',
        {'password': newPassword},
        where: 'email = ?',
        whereArgs: [email],
      );
      return rowsUpdated > 0;
    } catch (e) {
      print('비밀번호 변경 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> insertPatientChart(String patientId, Map<String, dynamic> chartData) async {
    final db = await database;
    try {
      await db.insert('patientchart', {
        'patientId': patientId,
        'originalImage': chartData['originalImage'],
        'resultImage': chartData['resultImage'],
        'findings': chartData['findings'],
        'painLevel': chartData['painLevel'],
        'note': chartData['note'],
        'stomcount': chartData['stomcount'],
        'date': DateTime.now().toIso8601String(),
        'stomsize': chartData['stomsize'],
      });
      return true;
    } catch (e) {
      print('차트 추가 중 오류 발생: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPatientCharts(String patientId) async {
    final db = await database;
    final charts = await db.query(
      'patientchart',
      where: 'patientId = ?',
      whereArgs: [patientId],
      orderBy: 'date DESC',
    );

    return charts.map((chart) {
      final date = DateTime.parse(chart['date'] as String);
      return {
        ...chart,
        'displayDate': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'displayTime': '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
      };
    }).toList();
  }

  Future<bool> deletePatientCharts(String patientId) async {
    final db = await database;
    try {
      await db.delete(
        'patientchart',
        where: 'patientId = ?',
        whereArgs: [patientId],
      );
      return true;
    } catch (e) {
      print('차트 삭제 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> deleteChart(String chartId) async {
    final db = await database;
    try {
      await db.delete(
        'patientchart',
        where: 'chartId = ?',
        whereArgs: [chartId],
      );
      return true;
    } catch (e) {
      print('차트 삭제 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> saveImagePath(String patientId, String imagePath) async {
    final db = await database;
    try {
      await db.insert(
        'patientchart',
        {
          'patientId': patientId,
          'originalImage': imagePath,
          'date': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('이미지 경로 저장 중 오류 발생: $e');
      return false;
    }
  }

  Future<String> getLatestStomCount(String patientId) async {
    print('------ getLatestStomCount 호출 ------');
    print('요청된 환자 ID: $patientId');
    
    final db = await database;
    final charts = await db.query(
      'patientchart',
      columns: ['stomcount'],
      where: 'patientId = ?',
      whereArgs: [patientId],
      orderBy: 'date DESC',
      limit: 1
    );

    print('조회된 차트 데이터: $charts');

    if (charts.isNotEmpty && charts.first['stomcount'] != null) {
      final stomcount = charts.first['stomcount'] as String;
      print('반환되는 stomcount: $stomcount');
      return stomcount;
    }
    
    print('기본값 0 반환');
    return '0';
  }

  Future<Map<String, dynamic>?> getUserByEmailAndLicenseKey(String email, String licenseKey) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? AND licenseKey = ?',
      whereArgs: [email, licenseKey],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<bool> updatePasswordWithoutOldPassword(String email, String newPassword) async {
    final db = await database;
    try {
      final rowsUpdated = await db.update(
        'users',
        {'password': newPassword},
        where: 'email = ?',
        whereArgs: [email],
      );
      return rowsUpdated > 0;
    } catch (e) {
      print('비밀번호 재설정 중 오류 발생: $e');
      return false;
    }
  }
}