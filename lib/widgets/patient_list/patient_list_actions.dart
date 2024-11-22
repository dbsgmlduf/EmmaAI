import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PatientListActions extends StatefulWidget {
  final bool isPatientSelected;
  final VoidCallback onImageDeleted;
  final Function(String) onImageUploaded;
  final VoidCallback onImageAnalyzed;
  final double buttonWidth;
  final double buttonHeight;
  final double iconSize;
  final double textSize;

  const PatientListActions({
    required this.isPatientSelected,
    required this.onImageDeleted,
    required this.onImageUploaded,
    required this.onImageAnalyzed,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.iconSize,
    required this.textSize,
  });

  @override
  _PatientListActionsState createState() => _PatientListActionsState();
}

class _PatientListActionsState extends State<PatientListActions> {
  Future<void> _uploadImage() async {
  final ImagePicker _picker = ImagePicker();
  
  try {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      String extension = image.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
        // 원본 파일 경로를 직접 사용
        widget.onImageUploaded(image.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('지원되는 이미지 형식: JPG, JPEG, PNG, GIF, BMP, WEBP'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    print('이미지 업로드 중 오류 발생: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('이미지 업로드 중 오류가 발생했습니다.'),
        backgroundColor: Colors.red,
      ),
    );
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (photo != null) {
        // 갤러리에 저장
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String newPath = '${photo.path}_$timestamp.jpg';
        await File(photo.path).copy(newPath);
        
        // 이미지 업로드 콜백 호출
        widget.onImageUploaded(newPath);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진이 갤러리에 저장되었습니다.')),
        );
      }
    } catch (e) {
      print('카메라 촬영 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('카메라 촬영 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionButton(
            Icons.camera_alt_outlined,
            'CAMERA',
            onPressed: widget.isPatientSelected ? _takePhoto : null,
          ),
          SizedBox(height: 5),
          _buildActionButton(
            Icons.image_outlined,
            'IMAGE',
            onPressed: widget.isPatientSelected ? _uploadImage : null,
          ),
          SizedBox(height: 5),
          _buildActionButton(
            Icons.image_not_supported_outlined,
            'DELETE',
            onPressed: widget.isPatientSelected ? widget.onImageDeleted : null,
          ),
          SizedBox(height: 5),
          _buildActionButton(
            Icons.search,
            'ANALYZE',
            onPressed: widget.isPatientSelected ? widget.onImageAnalyzed : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, {VoidCallback? onPressed}) {
    return Container(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 2),
        borderRadius: BorderRadius.circular(widget.buttonHeight / 2),
      ),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey, size: widget.iconSize),
        label: Text(text, style: TextStyle(color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey, fontSize: widget.textSize)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF40C2FF),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.buttonHeight / 2),
          ),
        ),
      ),
    );
  }
}