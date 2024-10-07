import 'package:flutter/material.dart';
import '../widgets/patient_list.dart';
import '../widgets/analysis_result.dart';
import '../models/patient_data.dart';

class EmmaAIScreen extends StatefulWidget {
  @override
  _EmmaAIScreenState createState() => _EmmaAIScreenState();
}

class _EmmaAIScreenState extends State<EmmaAIScreen> {
  Patient? selectedPatient;
  Map<String, String> patientImages = {};

  void selectPatient(Patient patient) {
    setState(() {
      selectedPatient = patient;
    });
  }

  void onImageUploaded(String imagePath) {
    if (selectedPatient != null) {
      setState(() {
        patientImages[selectedPatient!.id] = imagePath;
      });
    }
  }

  void deleteImage() {
    if (selectedPatient != null) {
      setState(() {
        patientImages.remove(selectedPatient!.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지가 삭제되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'emma ai',
            style: TextStyle(
              fontSize: 61,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF40C2FF),
            ),
          ),
          leading: Row(
            children: [
              SizedBox(width: 10),
              _buildCustomIcon(Icons.settings, 50),
              SizedBox(width: 10),
              _buildCustomIcon(Icons.help_outline, 50),
            ],
          ),
          leadingWidth: 120,
          actions: [
            _buildCustomIcon(Icons.account_circle, 60),
            SizedBox(width: 10),
            _buildCustomIcon(Icons.more_vert, 40),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: PatientList(
                selectedPatientId: selectedPatient?.id,
                onPatientSelected: selectPatient,
                onImageUploaded: onImageUploaded,
                onImageDeleted: deleteImage,
                isPatientSelected: selectedPatient != null,
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: AnalysisResult(
                patient: selectedPatient,
                imagePath: selectedPatient != null ? patientImages[selectedPatient!.id] : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomIcon(IconData icon, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        iconSize: size,
        padding: EdgeInsets.zero,
        onPressed: () {},
      ),
    );
  }
}