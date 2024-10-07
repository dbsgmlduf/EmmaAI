import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Patient {
  final String id;
  final String date;
  final int age;
  final String result;
  final String sex;
  final String note;

  Patient({
    required this.id,
    required this.date,
    required this.age,
    required this.result,
    required this.sex,
    this.note = '',
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      date: json['date'],
      age: json['age'],
      result: json['result'],
      sex: json['sex'],
      note: json['note'] ?? '',
    );
  }
}

Future<List<Patient>> loadPatients() async {
  String jsonString = await rootBundle.loadString('assets/dummy_patients.json');
  final jsonResponse = json.decode(jsonString);

  return (jsonResponse['patients'] as List)
      .map((patientJson) => Patient.fromJson(patientJson))
      .toList();
}