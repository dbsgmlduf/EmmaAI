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
  _AnalysisResultState createState() => _AnalysisResultState();
}

class _AnalysisResultState extends State<AnalysisResult> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (keyboardHeight > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    final widthRatio = screenWidth / 1920;
    final heightRatio = screenHeight / 1200;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 1164 * widthRatio,
              height: 644 * heightRatio,
              child: ImageSection(
                uploadedImagePath: widget.uploadedImagePath,
                analysisImagePath: widget.analysisImagePath,
                onUpload: widget.onNewAnalysis,
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
                  if (widget.selectedChartId != null) {
                    widget.onChartDeleted(widget.selectedChartId!);
                  }
                },
                containerWidth: 590 * widthRatio,
                containerHeight: 544 * heightRatio,
              ),
            ),
            SizedBox(height: 10 * heightRatio),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PatientInfoSection(patient: widget.patient),
                SizedBox(width: 10 * widthRatio),
                FindingsSection(
                  chart: widget.chart,
                  onFindingsChanged: (updatedChart) {
                    final newChart = {
                      ...widget.chart,
                      'findings': updatedChart['findings'],
                      'painLevel': updatedChart['painLevel'],
                      'originalImage': widget.uploadedImagePath,
                      'resultImage': widget.analysisImagePath,
                      'note': widget.patient?.note ?? '',
                      'stomcount': widget.chart['stomcount'] ?? '',
                      'stomsize': widget.chart['stomsize'] ?? '',
                    };
                    widget.updateChart(newChart);
                  },
                  isPatientSelected: widget.patient != null,
                ),
              ],
            ),
            SizedBox(height: 10 * heightRatio),
            NoteSection(
              initialNote: widget.chart['note'] ?? widget.patient?.note,
              onNoteSaved: widget.onNoteSaved,
              isPatientSelected: widget.patient != null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}