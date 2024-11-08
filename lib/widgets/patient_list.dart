import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';

class PatientList extends StatefulWidget {
  final List<Patient> patients;
  final String? selectedPatientId;
  final Function(Patient) onPatientSelected;
  final Function(String) onImageUploaded;
  final VoidCallback onImageDeleted;
  final VoidCallback onImageAnalyzed;
  final bool isPatientSelected;
  final String licenseKey;

  PatientList({
    required this.patients,
    this.selectedPatientId,
    required this.onPatientSelected,
    required this.onImageUploaded,
    required this.onImageDeleted,
    required this.onImageAnalyzed,
    required this.isPatientSelected,
    required this.licenseKey,
  });

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final listWidth = screenSize.width * 0.3;
    final listHeight = screenSize.height * 0.8;
    final headerFontSize = 16.0;
    final infoFontSize = 14.0;

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
          // 상단 아이콘 버튼들
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Color(0xFF40C2FF)),
                  onPressed: () {
                    // 검색 기능 구현
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Color(0xFF40C2FF)),
                  onPressed: () => _showAddPatientDialog(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Color(0xFF40C2FF)),
                  onPressed: widget.onImageDeleted,
                ),
              ],
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: Text('Date', style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
                Expanded(child: Text('ID', style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
                Expanded(child: Text('Age', style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
                Expanded(child: Text('Result', style: TextStyle(color: Color(0xFF40C2FF), fontSize: headerFontSize))),
              ],
            ),
          ),
          Divider(color: Color(0xFF40C2FF), thickness: 1),
          // 환자 리스트
          Expanded(
            child: ListView.builder(
              itemCount: widget.patients.length,
              itemBuilder: (context, index) {
                final patient = widget.patients[index];
                return ListTile(
                  selected: widget.selectedPatientId == patient.id,
                  selectedTileColor: Colors.blue.withOpacity(0.2),
                  onTap: () => widget.onPatientSelected(patient),
                  title: Row(
                    children: [
                      Expanded(child: Text(patient.date, style: TextStyle(color: Colors.white, fontSize: infoFontSize))),
                      Expanded(child: Text(patient.id, style: TextStyle(color: Colors.white, fontSize: infoFontSize))),
                      Expanded(child: Text(patient.age.toString(), style: TextStyle(color: Colors.white, fontSize: infoFontSize))),
                      Expanded(
                        child: CircleAvatar(
                          backgroundColor: _getResultColor(patient.resultNo),
                          radius: 8,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 하단 버튼들
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildActionButton(
                  Icons.delete,
                  'DELETE',
                  double.infinity,
                  50,
                  widget.isPatientSelected ? widget.onImageDeleted : null,
                ),
                SizedBox(height: 8),
                _buildActionButton(
                  Icons.upload,
                  'UPLOAD',
                  double.infinity,
                  50,
                  widget.isPatientSelected ? _uploadImage : null,
                ),
                SizedBox(height: 8),
                _buildActionButton(
                  Icons.search,
                  'ANALYZE',
                  double.infinity,
                  50,
                  widget.isPatientSelected ? widget.onImageAnalyzed : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getResultColor(String resultNo) {
    switch (resultNo) {
      case 'normal':
        return Colors.blue;
      case 'abnormal':
        return Colors.red;
      case 'inconclusive':
      default:
        return Colors.grey;
    }
  }

  Widget _buildActionButton(IconData icon, String text, double width, double height, VoidCallback? onPressed) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF)),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextButton.icon(
        icon: Icon(icon, color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey),
        label: Text(text, style: TextStyle(color: onPressed != null ? Color(0xFF40C2FF) : Colors.grey)),
        onPressed: onPressed,
      ),
    );
  }

  Future<void> _uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      widget.onImageUploaded(image.path);
    }
  }

  void _showAddPatientDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    String selectedSex = 'M';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text('새 환자 추가', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: idController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: '환자 ID',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF40C2FF)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: ageController,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '나이',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF40C2FF)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButton<String>(
                      value: selectedSex,
                      dropdownColor: Colors.black,
                      style: TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSex = newValue ?? 'M';
                        });
                      },
                      items: <String>['M', 'F']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('취소', style: TextStyle(color: Color(0xFF40C2FF))),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('추가', style: TextStyle(color: Color(0xFF40C2FF))),
                  onPressed: () async {
                    if (idController.text.isNotEmpty && ageController.text.isNotEmpty) {
                      final newPatient = Patient(
                        id: idController.text,
                        date: DateTime.now().toString().split(' ')[0],
                        age: int.parse(ageController.text),
                        sex: selectedSex,
                        result: '',
                        resultNo: 'inconclusive',
                        note: '',
                      );

                      final success = await PatientService.addPatient(newPatient, widget.licenseKey);
                      if (success) {
                        Navigator.of(context).pop();
                        setState(() {
                          widget.patients.add(newPatient);
                        });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}