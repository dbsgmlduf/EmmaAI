import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import './analysis_sections/image_section.dart';
import './analysis_sections/patient_info_section.dart';
import './analysis_sections/findings_section.dart';
import './analysis_sections/note_section.dart';

class AnalysisResult extends StatefulWidget {
  final Patient? patient;
  final String? uploadedImagePath;
  final String? analysisImagePath;
  final Function(String) onNoteSaved;
  final Map<String, dynamic> chart;
  final List<dynamic> chartHistory;
  final Function(Map<String, dynamic>) updateChart;
  final Function(Map<String, dynamic>) onChartSaved;

  const AnalysisResult({
    this.patient,
    this.uploadedImagePath,
    this.analysisImagePath,
    required this.onNoteSaved,
    required this.chart,
    required this.chartHistory,
    required this.updateChart,
    required this.onChartSaved,
  });

  @override
  _AnalysisResultState createState() => _AnalysisResultState();
}

class _AnalysisResultState extends State<AnalysisResult> {
  final TextEditingController _noteController = TextEditingController();
  bool _isEditingNote = false;
  int _selectedHistoryIndex = -1;
  double _painLevel = 5.0;
  bool _isAphthousStomatitis = false;
  bool _isOralThrush = false;
  bool _isOralHerpes = false;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.chart['note'] ?? '';
    _updateValuesFromChart();
  }

  void _updateValuesFromChart() {
    if (widget.chart['painLevel'] != null) {
      _painLevel = double.parse(widget.chart['painLevel'].toString());
    }
    
    if (widget.chart['findings'] != null) {
      String findings = widget.chart['findings'].toString();
      _isAphthousStomatitis = findings == '1';
      _isOralHerpes = findings == '2';
      _isOralThrush = findings == '3';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageSection(
          uploadedImagePath: widget.uploadedImagePath,
          analysisImagePath: widget.analysisImagePath,
          onUpload: () {
            // 이미지 업로드 로직
          },
          onSave: () {
            final chartData = {
              'originalImage': widget.uploadedImagePath,
              'resultImage': widget.analysisImagePath,
              'findings': widget.chart['findings'] ?? '',
              'painLevel': widget.chart['painLevel'] ?? '',
              'note': widget.patient?.note ?? '',
              'stomcount': widget.chart['stomcount'] ?? '',
              'stomsize': widget.chart['stomsize'] ?? '',
            };
            widget.onChartSaved(chartData);
          },
          onDelete: () {
            // 이미지 삭제 로직
          },
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: PatientInfoSection(patient: widget.patient),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: FindingsSection(
                chart: widget.chart,
                onFindingsChanged: (findings) {
                  // findings 업데이트 로직
                },
                isPatientSelected: widget.patient != null,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        NoteSection(
          initialNote: widget.patient?.note,
          onNoteSaved: widget.onNoteSaved,
          isPatientSelected: widget.patient != null,
        ),
      ],
    );
  }
}