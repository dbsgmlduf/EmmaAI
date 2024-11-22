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

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    final parts = date.split('-');
    if (parts.length != 3) return date;
    
    // YYYY-MM-DD에서 YY/MM/DD로 변환
    return '${parts[0].substring(2)}/${parts[1]}/${parts[2]}';
  }

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
                Expanded(child: Text(_formatDate(patient.date), textAlign: TextAlign.center,
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