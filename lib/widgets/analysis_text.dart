import 'package:flutter/material.dart';

class ResultPanel extends StatelessWidget {
  final Map<String, dynamic> chart;

  const ResultPanel({required this.chart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RESULT', 
              style: TextStyle(
                color: Color(0xFF40C2FF), 
                fontSize: 24, 
                fontWeight: FontWeight.bold
              )),
          SizedBox(height: 16),
          Divider(
            color: Color(0xFF40C2FF),
            thickness: 2,
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 16), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STOM COUNT: ${chart['stomCount'] ?? 0}',
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                Divider(color: Colors.white, thickness: 1),
                SizedBox(height: 8),
                Text('STOM SIZE:',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPanel extends StatefulWidget {
  final List<dynamic> chartHistory;
  final Function(Map<String, dynamic>) onChartSelected;

  const HistoryPanel({
    required this.chartHistory,
    required this.onChartSelected,
  });

  @override
  _HistoryPanelState createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HISTORY',
            style: TextStyle(
              color: Color(0xFF40C2FF),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Color(0xFF40C2FF),
            thickness: 2,
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.chartHistory.length,
              itemBuilder: (context, index) {
                final chart = widget.chartHistory[index];
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onChartSelected(chart);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF40C2FF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${index + 1}. [ ${chart['displayDate']} ${chart['displayTime']} ]',
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Color(0xFF40C2FF)),
                onPressed: () {
                  // 이전 페이지 로직
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Color(0xFF40C2FF)),
                onPressed: () {
                  // 다음 페이지 로직
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}