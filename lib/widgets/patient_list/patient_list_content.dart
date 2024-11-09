import 'package:flutter/material.dart';
import '../../models/patient_data.dart';

class PatientListContent extends StatelessWidget {
  final List<Patient> patients;
  final String? selectedPatientId;
  final Function(Patient) onPatientSelected;
  final int currentPage;
  final int patientsPerPage;
  final double infoFontSize;

  const PatientListContent({
    required this.patients,
    required this.selectedPatientId,
    required this.onPatientSelected,
    required this.currentPage,
    required this.patientsPerPage,
    required this.infoFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final startIndex = currentPage * patientsPerPage;
    final endIndex = (startIndex + patientsPerPage) > patients.length
        ? patients.length
        : startIndex + patientsPerPage;
    final paginatedPatients = patients.sublist(startIndex, endIndex);

    return Expanded(
      child: ListView.builder(
        itemCount: paginatedPatients.length,
        itemBuilder: (context, index) {
          final patient = paginatedPatients[index];
          return ListTile(
            selected: selectedPatientId == patient.id,
            selectedTileColor: Colors.blue.withOpacity(0.2),
            onTap: () => onPatientSelected(patient),
            title: Row(
              children: [
                Expanded(child: Text(patient.date, textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: infoFontSize))),
                Expanded(child: Text(patient.id, textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: infoFontSize))),
                Expanded(child: Text(patient.age.toString(), textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: infoFontSize))),
                Expanded(child: Text(
                  patient.sex == 'Male' ? 'M' : 
                  patient.sex == 'Female' ? 'F' : 'O', 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: infoFontSize)
                )),
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: _getResultColor(patient.resultNo),
                    radius: 8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getResultColor(String resultNo) {
    switch (resultNo) {
      case 'positive':
        return Colors.red;
      case 'negative':
        return Colors.blue;
      default:
        return Colors.white;
    }
  }
}