import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/patient_data.dart';

class AnalysisResult extends StatefulWidget {
  final Patient? patient;
  final String? imagePath;
  final Function(String) onNoteSaved;

  AnalysisResult({this.patient, this.imagePath, required this.onNoteSaved});

  @override
  _AnalysisResultState createState() => _AnalysisResultState();
}

class _AnalysisResultState extends State<AnalysisResult> {
  final TextEditingController _noteController = TextEditingController();
  bool _isEditingNote = false;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.patient?.note ?? '';
  }

  @override
  void didUpdateWidget(AnalysisResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.patient?.id != oldWidget.patient?.id) {
      _noteController.text = widget.patient?.note ?? '';
      _isEditingNote = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final photoWidth = 810 / 1920 * screenWidth;
    final photoHeight = 440 / 1080 * screenHeight;
    final headerFontSize = 21 / 1080 * screenHeight;

    Widget _buildInfoRow(String title, String content) {
      return Row(
        children: [
          Text('$title :   ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize)),
          Text(content, style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      );
    }

    Widget _buildImage() {
      if (widget.imagePath == null) {
        return Center(
          child: Text('[ 사진 없음 ]', style: TextStyle(color: Colors.red)),
        );
      }

      Widget imageWidget;
      if (kIsWeb) {
        imageWidget = Image.network(
          widget.imagePath!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text('이미지 로드 실패', style: TextStyle(color: Colors.red)),
            );
          },
        );
      } else {
        imageWidget = Image.file(
          File(widget.imagePath!),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text('이미지 로드 실패', style: TextStyle(color: Colors.red)),
            );
          },
        );
      }

      return AspectRatio(
        aspectRatio: 16 / 9,
        child: FittedBox(
          fit: BoxFit.contain,
          child: imageWidget,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: photoWidth,
                height: photoHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF40C2FF), width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: _buildImage(),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: photoWidth,
                height: 180 / 1080 * screenHeight,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF40C2FF), width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoRow('User ID', widget.patient?.id ?? ''),
                    _buildInfoRow('Date', widget.patient?.date ?? ''),
                    _buildInfoRow('Sex', widget.patient?.sex ?? ''),
                    _buildInfoRow('Age', widget.patient?.age?.toString() ?? ''),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: photoWidth,
                height: 230 / 1080 * screenHeight,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF40C2FF), width: 3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(58),
                      bottomRight: Radius.circular(58)
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Note', style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize)),
                    SizedBox(height: 8),
                    Expanded(
                      child: widget.patient == null
                          ? Center(child: Text('환자를 선택해주세요', style: TextStyle(color: Colors.grey)))
                          : _isEditingNote
                          ? TextField(
                        controller: _noteController,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[800],
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      )
                          : SingleChildScrollView(
                             child: Text(_noteController.text,
                               style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: widget.patient == null ? null : () {
                            setState(() {
                              if (_isEditingNote) {
                                widget.onNoteSaved(_noteController.text);
                              }
                              _isEditingNote = !_isEditingNote;
                            });
                          },
                          child: Text(_isEditingNote ? 'Save' : 'Edit', style: TextStyle(color: Color(0xFF40C2FF))),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: widget.patient == null ? null : () {
                            setState(() {
                              _noteController.clear();
                              widget.onNoteSaved('');
                            });
                          },
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Result', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                height: 4,
                color: Color(0xFF40C2FF),
              ),
              SizedBox(height: 16),
              Text(widget.patient?.result ?? '', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 40),
              Text('Findings', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                height: 4,
                color: Color(0xFF40C2FF),
              ),
              SizedBox(height: 16),
              _buildFindingToggle('Aphthous stomatitis', true),
              _buildFindingToggle('Oral thrush', false),
              _buildFindingToggle('Oral herpes', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFindingToggle(String label, bool result) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        Switch(
          value: result,
          onChanged: (bool value) {
        
          },
          activeColor: Color(0xFF0676CB),
        ),
      ],
    );
  }
}