import 'package:flutter/material.dart';
import '../services/patient_service.dart';

Future<void> showDeleteConfirmationDialog(
  BuildContext context, 
  String patientId, 
  String licenseKey,
  Function loadPatients
) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFF40C2FF), width: 2),
        ),
        title: Text(
          "Delete Confirmation",
          style: TextStyle(color: Color(0xFF40C2FF), fontSize: 24),
        ),
        content: Text(
          "Are you sure you want to delete this item?",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            onPressed: () async {
              final success = await PatientService.deletePatient(patientId, licenseKey);
              if (success) {
                Navigator.of(context).pop();
                loadPatients();
              }
            },
          ),
        ],
      );
    },
  );
}