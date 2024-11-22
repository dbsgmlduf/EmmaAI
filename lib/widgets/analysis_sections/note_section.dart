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
  void didUpdateWidget(NoteSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialNote != oldWidget.initialNote) {
      _noteController.text = widget.initialNote ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = 22 * (screenHeight / 1200);

    return Container(
      width: MediaQuery.of(context).size.width * (1164/1920),
      height: MediaQuery.of(context).size.height * (186/1200),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Note', style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)),
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
                      style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)),
                  ),
                  TextButton(
                    onPressed: widget.isPatientSelected ? () {
                      setState(() {
                        _noteController.clear();
                        widget.onNoteSaved('');
                      });
                    } : null,
                    child: Text('Delete', 
                      style: TextStyle(color: Colors.red, fontSize: fontSize)),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: TextField(
              controller: _noteController,
              enabled: _isEditing,
              maxLines: null,
              style: TextStyle(color: Colors.white, fontSize: fontSize),
              decoration: InputDecoration(
                hintText: '환자를 선택해주세요',
                hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF40C2FF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF40C2FF)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 