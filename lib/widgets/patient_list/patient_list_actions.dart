import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        String extension = image.path.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionButton(
            Icons.delete,
            'DELETE',
            onPressed: widget.isPatientSelected ? widget.onImageDeleted : null,
          ),
          SizedBox(height: 8),
          _buildActionButton(
            Icons.upload,
            'UPLOAD',
            onPressed: widget.isPatientSelected ? _uploadImage : null,
          ),
          SizedBox(height: 8),
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