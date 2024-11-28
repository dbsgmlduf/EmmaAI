import 'package:flutter/material.dart';

class FindingsSection extends StatefulWidget {
  final Map<String, dynamic> chart;
  final Function(Map<String, dynamic>) onFindingsChanged;
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
  void _onSwitchChanged(String finding) {
    if (!widget.isPatientSelected || widget.chart['chartId'] != null) return;

    final updatedChart = Map<String, dynamic>.from(widget.chart);
    updatedChart['findings'] = finding;
    widget.onFindingsChanged(updatedChart);
  }

  void _onPainLevelChanged(double value) {
    if (!widget.isPatientSelected || widget.chart['chartId'] != null) return;

    final updatedChart = Map<String, dynamic>.from(widget.chart);
    updatedChart['painLevel'] = value.toString();
    widget.onFindingsChanged(updatedChart);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = 22 * (screenHeight / 1200);

    final isAphthousStomatitis = widget.chart['findings'] == '1';
    final isOralThrush = widget.chart['findings'] == '2';
    final isOralHerpes = widget.chart['findings'] == '3';
    final painLevel = widget.chart['painLevel'] != null ?
    double.tryParse(widget.chart['painLevel'].toString()) ?? 5.0 : 5.0;

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
                          color: isAphthousStomatitis ? Color(0xFFFFAE00) : Colors.white,
                          fontSize: fontSize
                      )
                  ),
                ),
                SizedBox(
                  width: 75 * (screenWidth / 1920),
                  height: 40 * (screenHeight / 1200),
                  child: Switch(
                    value: isAphthousStomatitis,
                    onChanged: widget.isPatientSelected && widget.chart['chartId'] == null
                        ? (value) => _onSwitchChanged('1')
                        : null,
                    activeColor: Color(0xFF40C2FF),
                  ),
                ),
                SizedBox(width: 16),
                Text('Oral thrush',
                    style: TextStyle(
                        color: isOralThrush ? Color(0xFFFFAE00) : Colors.white,
                        fontSize: fontSize
                    )
                ),
                Switch(
                  value: isOralThrush,
                  onChanged: widget.isPatientSelected && widget.chart['chartId'] == null
                      ? (value) => _onSwitchChanged('2')
                      : null,
                  activeColor: Color(0xFF40C2FF),
                ),
                SizedBox(width: 16),
                Text('Oral herpes',
                    style: TextStyle(
                        color: isOralHerpes ? Color(0xFFFFAE00) : Colors.white,
                        fontSize: fontSize
                    )
                ),
                Switch(
                  value: isOralHerpes,
                  onChanged: widget.isPatientSelected && widget.chart['chartId'] == null
                      ? (value) => _onSwitchChanged('3')
                      : null,
                  activeColor: Color(0xFF40C2FF),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                    'Pain Level',
                    style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)
                ),
                Text(
                    '${painLevel.round()}',
                    style: TextStyle(color: Colors.white, fontSize: fontSize)
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 6 * (screenHeight / 1200),
                    child: Slider(
                      value: painLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: painLevel.round().toString(),
                      activeColor: Color(0xFF40C2FF),
                      inactiveColor: Colors.grey,
                      onChanged: widget.isPatientSelected && widget.chart['chartId'] == null
                          ? _onPainLevelChanged
                          : null,
                      thumbColor: Color(0xFF40C2FF),
                      overlayColor: MaterialStateProperty.all(Color(0xFF40C2FF).withOpacity(0.2)),
                      secondaryActiveColor: Color(0xFF40C2FF),
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