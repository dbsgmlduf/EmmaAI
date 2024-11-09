import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../models/patient_data.dart';

Future<void> showAddPatientDialog(
  BuildContext context, 
  String licenseKey,
  VoidCallback onPatientsUpdated
) async {
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String selectedGender = 'Male';

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text("Add New Patient", style: TextStyle(color: Color(0xFF40C2FF))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: patientIdController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Patient ID',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: ageController,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedGender,
                  dropdownColor: Colors.black,
                  style: TextStyle(color: Colors.white),
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text("Add", style: TextStyle(color: Color(0xFF40C2FF))),
                onPressed: () async {
                  if (patientIdController.text.isNotEmpty && 
                      ageController.text.isNotEmpty) {
                    final patient = Patient(
                      id: patientIdController.text,
                      date: DateTime.now().toString().split(' ')[0],
                      age: int.parse(ageController.text),
                      sex: selectedGender,
                      result: '',
                      resultNo: '',
                      note: '',
                    );
                    
                    final success = await PatientService.addPatient(patient, licenseKey);
                    if (success) {
                      Navigator.of(context).pop();
                      onPatientsUpdated();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Patient added successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error occurred while adding patient')),
                      );
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}