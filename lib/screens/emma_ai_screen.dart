import 'package:flutter/material.dart';
import '../widgets/patient_list.dart';
import '../widgets/analysis_result.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';
import '../widgets/custom_header.dart';
import '../widgets/analysis_text.dart';
import '../services/database_helper.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../dialog/common_dialog.dart';


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

  void deleteImage() async {
    if (selectedPatient != null) {
      setState(() {
        // 이미지 경로만 초기화
        patientImages.remove(selectedPatient!.id);
        patientAnalysisImages.remove(selectedPatient!.id);
        
        // 차트 및 분석 결과 초기화
        chart = {
          'stomcount': '0',
          'stomsize': '0',
          'findings': '',
          'painLevel': '0',
          'note': '',
          'chartId': null,
          'originalImage': null,
          'resultImage': null,
        };
        
        // 환자 노트 초기화
        int index = patients.indexWhere((p) => p.id == selectedPatient!.id);
        if (index != -1) {
          patients[index] = patients[index].copyWith(note: '');
          selectedPatient = patients[index];
        }
        
        // 히스토리 초기화
        chartHistory = [];
      });
      
      showCommonDialog(context, '완료', '이미지가 삭제되었습니다.');
    }
  }

  Future<void> analyzeImage() async {
    if (selectedPatient == null || !patientImages.containsKey(selectedPatient!.id)) {
      showCommonDialog(context, '알림', '분석할 이미지가 없습니다.\n먼저 이미지를 업로드해주세요.');
      return;
    }

    try {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('결과 대기중입니다...'),
                ],
              ),
            ),
          ),
        ),
      );

      // API 요청 준비
      final uri = Uri.parse('https://api.emmaet.com/mouth');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Accept': '*/*',
        });

      // 이미지 파일 처리
      final imageFile = File(patientImages[selectedPatient!.id]!);
      if (!await imageFile.exists()) {
        throw Exception('이미지 파일을 찾을 수 없습니다.');
      }

      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: path.basename(imageFile.path),
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      // API 요청 전송 및 응답 처리
      final response = await request.send().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('API 요청 시간이 초과되었습니다.');
        },
      );

      if (!context.mounted) return;
      Navigator.pop(context); // 로딩 다이얼로그 닫기

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);

        await _processAnalysisResult(jsonResponse);
      } else {
        throw Exception('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        showCommonDialog(context, '오류', '이미지 분석 중 오류가 발생했습니다.\n$e');
      }
    }
  }

  Future<void> _processAnalysisResult(Map<String, dynamic> jsonResponse) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = "EMMA_Analysis_${selectedPatient!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final newPath = path.join(appDir.path, 'analysis_images', fileName);

    final analysisDir = Directory(path.join(appDir.path, 'analysis_images'));
    if (!await analysisDir.exists()) {
      await analysisDir.create(recursive: true);
    }

    final imageBytes = base64Decode(jsonResponse['masked_image']);
    await File(newPath).writeAsBytes(imageBytes);

    setState(() {
      patientAnalysisImages[selectedPatient!.id] = newPath;
      chart = {
        'stomcount': jsonResponse['stom_count']?.toString() ?? '0',
        'stomsize': jsonResponse['stom_size']?.toString() ?? '0',
      };
    });

    if (context.mounted) {
      showCommonDialog(context, '완료', '분석이 완료되었습니다.');
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
      showCommonDialog(context, '완료', '노트가 저장되었습니다.');
    }
  }

  void deletePatient(String patientId) async {
    // 먼저 환자의 차트 기록 삭제
    final chartsDeleted = await DatabaseHelper.instance.deletePatientCharts(patientId);
    
    if (chartsDeleted) {
      // 차트 삭제 성공 후 환자 정보 삭제
      final success = await DatabaseHelper.instance.deletePatient(patientId, widget.licenseKey);
      
      if (success) {
        setState(() {
          patients.removeWhere((p) => p.id == patientId);
          if (selectedPatient?.id == patientId) {
            selectedPatient = null;
            chartHistory = [];
          }
        });
        showCommonDialog(context, '완료', '환자가 삭제되었습니다.');
      } else {
        print('환자 정보 삭제 실패: patientId=$patientId, licenseKey=${widget.licenseKey}');
        showCommonDialog(context, '오류', '환자 정보 삭제 중 오류가 발생했습니다.', isError: true);
      }
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
        // 저장 성공 후 바로 차트 히스토리 업데이트
        final updatedCharts = await DatabaseHelper.instance.getPatientCharts(selectedPatient!.id);
        setState(() {
          chartHistory = updatedCharts;
        });
        showCommonDialog(context, '완료', '차트가 저장되었습니다.');
      } else {
        showCommonDialog(context, '오류', '차트 저장 중 오류가 발생했습니다.', isError: true);
      }
    }
  }

  void deleteChart(String chartId) async {
    final success = await DatabaseHelper.instance.deleteChart(chartId);
    if (success) {
      // 차트 삭제 후 바로 히스토리 업데이트
      final updatedCharts = await DatabaseHelper.instance.getPatientCharts(selectedPatient!.id);
      setState(() {
        chartHistory = updatedCharts;
      });
      showCommonDialog(context, '완료', '기록이 삭제되었습니다.');
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (4/18),
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
                    flex: 6,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (2/18),
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