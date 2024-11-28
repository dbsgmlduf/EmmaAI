import 'package:flutter/material.dart';
import 'dart:io';

class ImageSection extends StatelessWidget {
  final String? uploadedImagePath;
  final String? analysisImagePath;
  final VoidCallback? onUpload;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final double containerWidth;
  final double containerHeight;

  const ImageSection({
    this.uploadedImagePath,
    this.analysisImagePath,
    this.onUpload,
    this.onSave,
    this.onDelete,
    required this.containerWidth,
    required this.containerHeight,
  });

  Widget _buildImage(String? imagePath, double fontSize) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF40C2FF), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text('Failed to load image',
            style: TextStyle(color: Colors.red, fontSize: fontSize),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = 22 * (screenHeight / 1200);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              children: [
                Icon(Icons.my_library_books_sharp, color: Color(0xFF40C2FF), size: 28),
                SizedBox(width: 8),
                Text(
                  'Date of Consultation [ Today : ${DateTime.now().toString().substring(0, 10)} ]',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 40),
                  onPressed: onUpload,
                  tooltip: '추가',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 20),
                Text(
                  '|',
                  style: TextStyle(
                    color: Color(0xFF40C2FF),
                    fontSize: fontSize,
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 40),
                  onPressed: onSave,
                  tooltip: '저장',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 20),
                Text(
                  '|',
                  style: TextStyle(
                    color: Color(0xFF40C2FF),
                    fontSize: fontSize,
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.white, size: 40),
                  onPressed: onDelete,
                  tooltip: '삭제',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    child: _buildImage(uploadedImagePath,fontSize),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    child: _buildImage(analysisImagePath,fontSize),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 