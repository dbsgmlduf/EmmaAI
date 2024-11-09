import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PatientListActions extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionButton(
            Icons.delete,
            'DELETE',
            onPressed: isPatientSelected ? onImageDeleted : null,
          ),
          SizedBox(height: 8),
          _buildActionButton(
            Icons.upload,
            'UPLOAD',
            onPressed: isPatientSelected ? _uploadImage : null,
          ),
          SizedBox(height: 8),
          _buildActionButton(
            Icons.search,
            'ANALYZE',
            onPressed: isPatientSelected ? onImageAnalyzed : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, {VoidCallback? onPressed}) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 2),
        borderRadius: BorderRadius.circular(buttonHeight / 2),
      ),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey, size: iconSize),
        label: Text(text, style: TextStyle(color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey, fontSize: textSize)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF40C2FF),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonHeight / 2),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      onImageUploaded(image.path);
    }
  }
}