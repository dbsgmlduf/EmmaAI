import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/patient_data.dart';

class PatientList extends StatefulWidget {
  final String? selectedPatientId;
  final Function(Patient) onPatientSelected;
  final Function(String) onImageUploaded;
  final VoidCallback onImageDeleted;
  final bool isPatientSelected;

  PatientList({
    this.selectedPatientId,
    required this.onPatientSelected,
    required this.onImageUploaded,
    required this.onImageDeleted,
    required this.isPatientSelected,
  });

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  List<Patient> patients = [];
  int currentPage = 0;
  int itemsPerPage = 12;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final loadedPatients = await loadPatients();
    setState(() {
      patients = loadedPatients;
    });
  }

  List<Patient> get currentPagePatients {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (currentPage + 1) * itemsPerPage;
    return patients.sublist(startIndex, endIndex.clamp(0, patients.length));
  }

  void nextPage() {
    if ((currentPage + 1) * itemsPerPage < patients.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (widget.isPatientSelected) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        widget.onImageUploaded(image.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final listWidth = 566 / 1920 * screenWidth;
    final listHeight = 895 / 1080 * screenHeight;

    final headerFontSize = 27 / 1080 * screenHeight;
    final infoFontSize = 20 / 1080 * screenHeight;

    final buttonWidth = 462 / 1920 * screenWidth;
    final buttonHeight = 55 / 1080 * screenHeight;
    final iconSize = 30 / 1080 * screenHeight;
    final textSize = 25 / 1080 * screenHeight;

    return Container(
      width: listWidth,
      height: listHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(58),
          bottomRight: Radius.circular(58),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text('Date', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
                Expanded(child: Text('ID', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
                Expanded(child: Text('Age', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
                Expanded(child: Text('Result', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
              ],
            ),
          ),
          Divider(color: Color(0xFF40C2FF), endIndent: 40, indent: 40, thickness: 3),
          Expanded(
            child: ListView.builder(
              itemCount: currentPagePatients.length,
              itemBuilder: (context, index) {
                final patient = currentPagePatients[index];
                final isSelected = patient.id == widget.selectedPatientId;
                return GestureDetector(
                  onTap: () => widget.onPatientSelected(patient),
                  child: Container(
                    color: isSelected ? Color(0xFF40C2FF).withOpacity(0.3) : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text(patient.date, textAlign: TextAlign.center, style: TextStyle(fontSize: infoFontSize))),
                          Expanded(child: Text(patient.id, textAlign: TextAlign.center, style: TextStyle(fontSize: infoFontSize))),
                          Expanded(child: Text(patient.age.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: infoFontSize))),
                          Expanded(
                            child: CircleAvatar(
                              backgroundColor: _getResultColor(patient.result),
                              radius: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF40C2FF), size: 30),
                  onPressed: previousPage,
                ),
                Text('|', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 30)),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Color(0xFF40C2FF), size: 30),
                  onPressed: nextPage,
                ),
              ],
            ),
          ),
          Divider(color: Color(0xFF40C2FF), endIndent: 40, indent: 40, thickness: 3),
          SizedBox(height: 16),
          _buildActionButton(
            Icons.delete,
            'DELETE',
            buttonWidth,
            buttonHeight,
            iconSize,
            textSize,
            onPressed: widget.isPatientSelected ? widget.onImageDeleted : null,
          ),
          SizedBox(height: 8),
          _buildActionButton(
            Icons.upload,
            'UPLOAD',
            buttonWidth,
            buttonHeight,
            iconSize,
            textSize,
            onPressed: widget.isPatientSelected ? _uploadImage : null,
          ),
          SizedBox(height: 8),
          _buildActionButton(Icons.search, 'ANALYZE', buttonWidth, buttonHeight, iconSize, textSize),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Color _getResultColor(String result) {
    switch (result) {
      case 'normal':
        return Colors.blue;
      case 'abnormal':
        return Colors.red;
      case 'inconclusive':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActionButton(IconData icon, String text, double width, double height, double iconSize, double textSize, {VoidCallback? onPressed}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 2),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey, size: iconSize),
        label: Text(
          text,
          style: TextStyle(color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey, fontSize: textSize),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF40C2FF),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}