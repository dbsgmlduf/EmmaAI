import 'package:flutter/material.dart';

class FindingsSection extends StatefulWidget {
  final Map<String, dynamic> chart;
  final Function(String) onFindingsChanged;
  final bool isPatientSelected;

  const FindingsSection({
    required this.chart,
    required this.onFindingsChanged,
    required this.isPatientSelected,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = 22 * (screenHeight / 1200);
    
    return Container(
      width: MediaQuery.of(context).size.width * (834/1920),
      height: MediaQuery.of(context).size.height * (180/1200),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Findings', style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text('Aphthous stomatitis', 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _isAphthousStomatitis ? Color(0xFFFFAE00) : Colors.white,
                      fontSize: fontSize
                    )
                  ),
                ),
                SizedBox(
                  width: 75 * (screenWidth / 1920),
                  height: 40 * (screenHeight / 1200),
                  child: Switch(
                    value: _isAphthousStomatitis,
                    onChanged: null,
                    activeColor: Color(0xFF40C2FF),
                  ),
                ),
                SizedBox(width: 16),
                Text('Oral thrush', 
                  style: TextStyle(
                    color: _isOralThrush ? Color(0xFFFFAE00) : Colors.white,
                    fontSize: fontSize
                  )
                ),
                Switch(
                  value: _isOralThrush,
                  onChanged: null,
                  activeColor: Color(0xFF40C2FF),
                ),
                SizedBox(width: 16),
                Text('Oral herpes', 
                  style: TextStyle(
                    color: _isOralHerpes ? Color(0xFFFFAE00) : Colors.white,
                    fontSize: fontSize
                  )
                ),
                Switch(
                  value: _isOralHerpes,
                  onChanged: null,
                  activeColor: Color(0xFF40C2FF),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text('Pain Level:', 
                  style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 6 * (screenHeight / 1200),
                    child: Slider(
                      value: _painLevel,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _painLevel.round().toString(),
                      onChanged: widget.isPatientSelected ? (value) {
                        setState(() => _painLevel = value);
                        widget.onFindingsChanged(value.toString());
                      } : null,
                      activeColor: Color(0xFF40C2FF),
                      inactiveColor: Colors.grey,
                    ),
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