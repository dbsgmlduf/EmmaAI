import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import './analysis_sections/image_section.dart';
import './analysis_sections/patient_info_section.dart';
import './analysis_sections/findings_section.dart';
import './analysis_sections/note_section.dart';

class AnalysisResult extends StatelessWidget {
  final Patient? patient;
  final String? uploadedImagePath;
  final String? analysisImagePath;
  final Function(String) onNoteSaved;
  final Map<String, dynamic> chart;
  final List<dynamic> chartHistory;
  final Function(Map<String, dynamic>) updateChart;
  final Function(Map<String, dynamic>) onChartSaved;
  final VoidCallback onNewAnalysis;
  final Function(String) onChartDeleted;
  final String? selectedChartId;

  const AnalysisResult({
    required this.patient,
    this.uploadedImagePath,
    this.analysisImagePath,
    required this.onNoteSaved,
    required this.chart,
    required this.chartHistory,
    required this.updateChart,
    required this.onChartSaved,
    required this.onNewAnalysis,
    required this.onChartDeleted,
    this.selectedChartId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageSection(
          uploadedImagePath: uploadedImagePath,
          analysisImagePath: analysisImagePath,
          onUpload: onNewAnalysis,
          onSave: () {
            final chartData = {
              'originalImage': uploadedImagePath,
              'resultImage': analysisImagePath,
              'findings': chart['findings'] ?? '',
              'painLevel': chart['painLevel'] ?? '',
              'note': patient?.note ?? '',
              'stomcount': chart['stomcount'] ?? '',
              'stomsize': chart['stomsize'] ?? '',
            };
            onChartSaved(chartData);
          },
          onDelete: () {
            if (selectedChartId != null) {
              onChartDeleted(selectedChartId!);
            }
          },
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: PatientInfoSection(patient: patient),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: FindingsSection(
                chart: chart,
                onFindingsChanged: (findings) {
                  // findings 업데이트 로직
                },
                isPatientSelected: patient != null,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        NoteSection(
          initialNote: chart['note'] ?? patient?.note,
          onNoteSaved: onNoteSaved,
          isPatientSelected: patient != null,
        ),
      ],
    );
  }
}