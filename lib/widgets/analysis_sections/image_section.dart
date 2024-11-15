import 'package:flutter/material.dart';
import 'dart:io';

class ImageSection extends StatelessWidget {
  final String? uploadedImagePath;
  final String? analysisImagePath;
  final VoidCallback? onUpload;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;

  const ImageSection({
    this.uploadedImagePath,
    this.analysisImagePath,
    this.onUpload,
    this.onSave,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: onUpload,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.save, color: Colors.white),
                  onPressed: onSave,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          Container(
            height: 290,
            padding: EdgeInsets.fromLTRB(1, 0, 1, 1),
            child: Row(
              children: [
                Expanded(child: _buildImageContainer('Original', uploadedImagePath)),
                SizedBox(width: 16),
                Expanded(child: _buildImageContainer('Analysis', analysisImagePath)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(String title, String? imagePath) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: imagePath == null
          ? Center(child: Text('[ 사진 없음 ]', style: TextStyle(color: Colors.red)))
          : GestureDetector(
              onLongPress: () {},
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
    );
  }
} 