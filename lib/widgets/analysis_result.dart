import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/patient_data.dart';

class AnalysisResult extends StatelessWidget {
  final Patient? patient;
  final String? imagePath;

  AnalysisResult({this.patient, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final photoWidth = 810 / 1920 * screenWidth;
    final photoHeight = 510 / 1080 * screenHeight;
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
      if (imagePath == null) {
        return Center(
          child: Text('[ 사진 없음 ]', style: TextStyle(color: Colors.red)),
        );
      }

      Widget imageWidget;
      if (kIsWeb) {
        imageWidget = Image.network(
          imagePath!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text('이미지 로드 실패', style: TextStyle(color: Colors.red)),
            );
          },
        );
      } else {
        imageWidget = Image.file(
          File(imagePath!),
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
                    _buildInfoRow('User ID', patient?.id ?? ''),
                    _buildInfoRow('Date', patient?.date ?? ''),
                    _buildInfoRow('Sex', patient?.sex ?? ''),
                    _buildInfoRow('Age', patient?.age?.toString() ?? ''),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: photoWidth,
                height: 170 / 1080 * screenHeight,
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
                    Text(patient?.note ?? '', style: TextStyle(color: Colors.white, fontSize: 16)),
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
              SizedBox(height: 200),
              Text('Findings', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                height: 4,
                color: Color(0xFF40C2FF),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Switch(value: true, onChanged: (value) {}, activeColor: Color(0xFF0676CB)),
                      SizedBox(height: 8),
                      Switch(value: false, onChanged: (value) {}, activeColor: Color(0xFF0676CB)),
                      SizedBox(height: 8),
                      Switch(value: false, onChanged: (value) {}, activeColor: Color(0xFF0676CB)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}