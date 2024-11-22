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

  Widget _buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF40C2FF), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text('[ 사진 없음 ]',
            style: TextStyle(color: Colors.red, fontSize: 16),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Row(
              children: [
                Icon(Icons.my_library_books_sharp, color: Color(0xFF40C2FF), size: 20),
                SizedBox(width: 8),
                Text(
                  'Date of Consultation [ Today : ${DateTime.now().toString().substring(0, 10)} ]',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.white),
                  onPressed: onUpload,
                  tooltip: '추가',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Text(
                  '|',
                  style: TextStyle(
                    color: Color(0xFF40C2FF),
                    fontSize: 30,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.check_circle_outline, color: Colors.white),
                  onPressed: onSave,
                  tooltip: '저장',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Text(
                  '|',
                  style: TextStyle(
                    color: Color(0xFF40C2FF),
                    fontSize: 30,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: onDelete,
                  tooltip: '삭제',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    child: _buildImage(uploadedImagePath),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    child: _buildImage(analysisImagePath),
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