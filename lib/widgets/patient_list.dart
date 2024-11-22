import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import 'patient_list/patient_list_header.dart';
import 'patient_list/patient_list_content.dart';
import 'patient_list/patient_list_actions.dart';

class PatientList extends StatefulWidget {
  final List<Patient> patients;
  final String? selectedPatientId;
  final Function(Patient) onPatientSelected;
  final Function(String) onImageUploaded;
  final VoidCallback onImageDeleted;
  final VoidCallback onImageAnalyzed;
  final bool isPatientSelected;
  final String licenseKey;
  final Function(String) onPatientDeleted;
  final VoidCallback onPatientsUpdated;

  const PatientList({
    required this.patients,
    this.selectedPatientId,
    required this.onPatientSelected,
    required this.onImageUploaded,
    required this.onImageDeleted,
    required this.onImageAnalyzed,
    required this.isPatientSelected,
    required this.licenseKey,
    required this.onPatientDeleted,
    required this.onPatientsUpdated,
  });

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  int _currentPage = 0;
  int _patientsPerPage = 6;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final listWidth = 395 / 1920 * screenWidth;
    final listHeight = 1010 / 1200 * screenHeight;
    final headerFontSize = 22 / 1200 * screenHeight;
    final infoFontSize = 18 / 1200 * screenHeight;
    final buttonWidth = 350 / 1920 * screenWidth;
    final buttonHeight = 44 / 1200 * screenHeight;
    final iconSize = 30 / 1200 * screenHeight;
    final textSize = 20 / 1200 * screenHeight;

    return Container(
      width: listWidth,
      height: listHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(58),
          bottomRight: Radius.circular(58),
        ),
      ),
      child: Column(
        children: [
          PatientListHeader(
            licenseKey: widget.licenseKey,
            patients: widget.patients,
            selectedPatientId: widget.selectedPatientId,
            onPatientDeleted: widget.onPatientDeleted,
            onPatientSelected: widget.onPatientSelected,
            onPatientsUpdated: widget.onPatientsUpdated,
          ),
          _buildColumnHeaders(headerFontSize),
          Divider(
            color: Color(0xFF40C2FF),
            endIndent: 10,
            indent: 10,
            thickness: 3,
          ),
          PatientListContent(
            patients: widget.patients,
            selectedPatientId: widget.selectedPatientId,
            onPatientSelected: widget.onPatientSelected,
            currentPage: _currentPage,
            patientsPerPage: _patientsPerPage,
            infoFontSize: infoFontSize,
          ),
          _buildPagination(),
          PatientListActions(
            isPatientSelected: widget.isPatientSelected,
            onImageDeleted: widget.onImageDeleted,
            onImageUploaded: widget.onImageUploaded,
            onImageAnalyzed: widget.onImageAnalyzed,
            buttonWidth: buttonWidth,
            buttonHeight: buttonHeight,
            iconSize: iconSize,
            textSize: textSize,
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeaders(double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text('DATE', textAlign: TextAlign.center, 
              style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize))),
          Expanded(child: Text('ID', textAlign: TextAlign.center, 
              style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize))),
          Expanded(child: Text('AGE', textAlign: TextAlign.center, 
              style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize))),
          Expanded(child: Text('SEX', textAlign: TextAlign.center, 
              style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize))),
          Expanded(child: Text('RESULT', textAlign: TextAlign.center, 
              style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize-1))),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF40C2FF)),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
          ),
          Text('|', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 30)),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Color(0xFF40C2FF)),
            onPressed: (_currentPage + 1) * _patientsPerPage < widget.patients.length
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}