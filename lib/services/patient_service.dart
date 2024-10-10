import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/patient_data.dart';

Future<List<Patient>> loadPatients() async {
  String jsonString = await rootBundle.loadString('assets/dummy_patients.json');
  final jsonResponse = json.decode(jsonString);

  return (jsonResponse['patients'] as List)
      .map((patientJson) => Patient.fromJson(patientJson))
      .toList();
}