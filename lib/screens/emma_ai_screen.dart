import 'package:flutter/material.dart';
import '../widgets/patient_list.dart';
import '../widgets/analysis_result.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';
import '../widgets/custom_header.dart';
import '../widgets/analysis_text.dart';
import '../services/database_helper.dart';

class EmmaAIScreen extends StatefulWidget {
  final String licenseKey;
  final String name;
  final String email;

  EmmaAIScreen({
    required this.licenseKey,
    required this.name,
    required this.email,
  });

  @override
  _EmmaAIScreenState createState() => _EmmaAIScreenState();
}

class _EmmaAIScreenState extends State<EmmaAIScreen> {
  Patient? selectedPatient;
  Map<String, String> patientImages = {};
  Map<String, String> patientAnalysisImages = {};
  List<Patient> patients = [];
  Map<String, dynamic> chart = {};
  List<dynamic> chartHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    List<Patient> loadedPatients = await PatientService.loadPatients(widget.licenseKey);
    setState(() {
      patients = loadedPatients;
    });
  }

  void selectPatient(Patient patient) async {
    final patientCharts = await DatabaseHelper.instance.getPatientCharts(patient.id);
    setState(() {
      selectedPatient = patient;
      chartHistory = patientCharts;
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

  void deletePatient(String patientId) async {
    final success = await PatientService.deletePatient(patientId, widget.licenseKey);
    if (success) {
      setState(() {
        patients.removeWhere((p) => p.id == patientId);
        if (selectedPatient?.id == patientId) {
          selectedPatient = null;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('환자가 삭제되었습니다.')),
      );
    }
  }

  void updateChart(Map<String, dynamic> selectedChart) {
    setState(() {
      chart = selectedChart;
      patientImages[selectedPatient!.id] = selectedChart['originalImage'] ?? '';
      patientAnalysisImages[selectedPatient!.id] = selectedChart['resultImage'] ?? '';
      
      // 선택된 환자의 노트 업데이트
      int index = patients.indexWhere((p) => p.id == selectedPatient!.id);
      if (index != -1) {
        patients[index] = patients[index].copyWith(note: selectedChart['note'] ?? '');
        selectedPatient = patients[index];
      }
    });
  }

  Future<void> saveChart(Map<String, dynamic> chartData) async {
    if (selectedPatient != null) {
      final success = await DatabaseHelper.instance.insertPatientChart(
        selectedPatient!.id,
        chartData,
      );
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차트가 저장되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('차트 저장 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void deleteChart(String chartId) async {
    final success = await DatabaseHelper.instance.deleteChart(chartId);
    if (success) {
      setState(() {
        chartHistory.removeWhere((chart) => chart['id'] == chartId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('기록이 삭제되었습니다.')),
      );
    }
  }

  void newAnalysis() {
    setState(() {
      chart = {};
      patientImages[selectedPatient!.id] = '';
      patientAnalysisImages[selectedPatient!.id] = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CustomHeader(
            name: widget.name,
            email: widget.email,
          ),
          Expanded(
            child: Padding(
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
                      licenseKey: widget.licenseKey,
                      onPatientDeleted: deletePatient,
                      onPatientsUpdated: _loadPatients,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: AnalysisResult(
                      patient: selectedPatient,
                      uploadedImagePath: selectedPatient != null ? patientImages[selectedPatient!.id] : null,
                      analysisImagePath: selectedPatient != null ? patientAnalysisImages[selectedPatient!.id] : null,
                      onNoteSaved: saveNote,
                      chart: chart,
                      chartHistory: chartHistory,
                      updateChart: updateChart,
                      onChartSaved: saveChart,
                      onNewAnalysis: newAnalysis,
                      onChartDeleted: deleteChart,
                      selectedChartId: chart['chartId']?.toString(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ResultPanel(chart: chart),
                        SizedBox(height: 16),
                        Expanded(
                          child: HistoryPanel(
                            chartHistory: chartHistory,
                            onChartSelected: updateChart,
                            onNewAnalysis: newAnalysis,
                            onChartDeleted: deleteChart,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}