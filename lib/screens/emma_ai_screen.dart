import 'package:flutter/material.dart';
import '../widgets/patient_list.dart';
import '../widgets/analysis_result.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';

class EmmaAIScreen extends StatefulWidget {
  @override
  _EmmaAIScreenState createState() => _EmmaAIScreenState();
}

class _EmmaAIScreenState extends State<EmmaAIScreen> {
  Patient? selectedPatient;
  Map<String, String> patientImages = {};
  Map<String, String> patientAnalysisImages = {};
  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    List<Patient> loadedPatients = await loadPatients();
    setState(() {
      patients = loadedPatients;
    });
  }

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
        patientAnalysisImages.remove(selectedPatient!.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지가 삭제되었습니다.')),
      );
    }
  }

  Future<void> analyzeImage() async {
    if (selectedPatient != null && patientImages.containsKey(selectedPatient!.id)) {
      // 여기에 서버에 이미지를 보내고 분석 결과를 받아오는 로직 구현
      setState(() {
        // 현재는 분석 결과 이미지 경로를 임의로 설정 작성.
        patientAnalysisImages[selectedPatient!.id] = 'path/to/analyzed/image.jpg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 분석이 완료되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('분석할 이미지가 없습니다. 먼저 이미지를 업로드해주세요.')),
      );
    }
  }

  void saveNote(String note) {
    if (selectedPatient != null) {
      setState(() {
        int index = patients.indexWhere((p) => p.id == selectedPatient!.id);
        if (index != -1) {
          patients[index] = patients[index].copyWith(note: note);
          selectedPatient = patients[index];
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('노트가 저장되었습니다.')),
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
                patients: patients,
                selectedPatientId: selectedPatient?.id,
                onPatientSelected: selectPatient,
                onImageUploaded: onImageUploaded,
                onImageDeleted: deleteImage,
                onImageAnalyzed: analyzeImage,
                isPatientSelected: selectedPatient != null,
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: AnalysisResult(
                patient: selectedPatient,
                uploadedImagePath: selectedPatient != null ? patientImages[selectedPatient!.id] : null,
                analysisImagePath: selectedPatient != null ? patientAnalysisImages[selectedPatient!.id] : null,
                onNoteSaved: saveNote,
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