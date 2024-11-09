import 'package:flutter/material.dart';

class FindingsSection extends StatefulWidget {
  final Map<String, dynamic> chart;
  final Function(String) onFindingsChanged;

  const FindingsSection({
    required this.chart,
    required this.onFindingsChanged,
  });

  @override
  _FindingsSectionState createState() => _FindingsSectionState();
}

class _FindingsSectionState extends State<FindingsSection> {
  bool _isAphthousStomatitis = false;
  bool _isOralThrush = false;
  bool _isOralHerpes = false;
  double _painLevel = 5.0;

  @override
  void initState() {
    super.initState();
    _updateValuesFromChart();
  }

  void _updateValuesFromChart() {
    if (widget.chart['painLevel'] != null) {
      _painLevel = double.parse(widget.chart['painLevel'].toString());
    }
    
    if (widget.chart['findings'] != null) {
      String findings = widget.chart['findings'].toString();
      _isAphthousStomatitis = findings == '1';
      _isOralHerpes = findings == '2';
      _isOralThrush = findings == '3';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Findings', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 18)),
          SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Aphthous stomatitis', style: TextStyle(color: Colors.white)),
              Switch(
                value: _isAphthousStomatitis,
                onChanged: (value) {
                  setState(() => _isAphthousStomatitis = value);
                  widget.onFindingsChanged('1');
                },
                activeColor: Color(0xFF40C2FF),
              ),
              SizedBox(width: 16),
              Text('Oral thrush', style: TextStyle(color: Colors.white)),
              Switch(
                value: _isOralThrush,
                onChanged: (value) {
                  setState(() => _isOralThrush = value);
                  widget.onFindingsChanged('3');
                },
                activeColor: Color(0xFF40C2FF),
              ),
              SizedBox(width: 16),
              Text('Oral herpes', style: TextStyle(color: Colors.white)),
              Switch(
                value: _isOralHerpes,
                onChanged: (value) {
                  setState(() => _isOralHerpes = value);
                  widget.onFindingsChanged('2');
                },
                activeColor: Color(0xFF40C2FF),
              ),
            ],
          ),
          SizedBox(height: 1),
          Divider(color: Color(0xFF40C2FF), thickness:2),
          SizedBox(height: 1),
          Row(
            children: [
              Text('Pain Level:', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 16)),
              SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _painLevel,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: Color(0xFF40C2FF),
                  inactiveColor: Colors.grey,
                  label: _painLevel.round().toString(),
                  onChanged: (value) {
                    setState(() => _painLevel = value);
                    widget.onFindingsChanged(value.toString());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 