import 'package:flutter/material.dart';

class NoteSection extends StatefulWidget {
  final String? initialNote;
  final Function(String) onNoteSaved;
  final bool isPatientSelected;

  const NoteSection({
    this.initialNote,
    required this.onNoteSaved,
    required this.isPatientSelected,
  });

  @override
  _NoteSectionState createState() => _NoteSectionState();
}

class _NoteSectionState extends State<NoteSection> {
  final TextEditingController _noteController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.initialNote ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Note', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 18)),
              Row(
                children: [
                  TextButton(
                    onPressed: widget.isPatientSelected ? () {
                      setState(() {
                        if (_isEditing) {
                          widget.onNoteSaved(_noteController.text);
                        }
                        _isEditing = !_isEditing;
                      });
                    } : null,
                    child: Text(_isEditing ? 'Save' : 'Edit',
                        style: TextStyle(color: Color(0xFF40C2FF))),
                  ),
                  TextButton(
                    onPressed: widget.isPatientSelected ? () {
                      setState(() {
                        _noteController.clear();
                        widget.onNoteSaved('');
                      });
                    } : null,
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          TextField(
            controller: _noteController,
            enabled: _isEditing,
            maxLines: 2,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '환자를 선택해주세요',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF40C2FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF40C2FF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 