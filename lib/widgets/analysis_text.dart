import 'package:flutter/material.dart';

class ResultPanel extends StatelessWidget {
  final Map<String, dynamic> chart;

  const ResultPanel({required this.chart});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESULT',
            style: TextStyle(
              color: Color(0xFF40C2FF),
              fontSize: 22*(screenHeight/1200),
              fontWeight: FontWeight.bold
            )
          ),
          Divider(color: Color(0xFF40C2FF), thickness: 2),
          Divider(color: Color(0xFF40C2FF), thickness: 2),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stom count ${chart['stomcount'] ?? '0'}',
                  style: TextStyle(color: Colors.white, fontSize: 18*(screenHeight/1200))
                ),
                SizedBox(height: 8),
                Divider(color: Colors.white, thickness: 1),
                SizedBox(height: 8),
                Text(
                  'Stom size ${chart['stomsize'] ?? '0'}',
                  style: TextStyle(color: Colors.white, fontSize: 18*(screenHeight/1200))
                ),
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
  final VoidCallback onNewAnalysis;
  final Function(String) onChartDeleted;

  const HistoryPanel({
    required this.chartHistory,
    required this.onChartSelected,
    required this.onNewAnalysis,
    required this.onChartDeleted,
  });

  @override
  _HistoryPanelState createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  int? selectedIndex;
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final int totalPages = (widget.chartHistory.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage < widget.chartHistory.length) 
        ? startIndex + _itemsPerPage 
        : widget.chartHistory.length;
    
    final currentPageItems = widget.chartHistory.sublist(startIndex, endIndex);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HISTORY',
            style: TextStyle(
              color: Color(0xFF40C2FF),
              fontSize: 22*(screenHeight/1200),
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Color(0xFF40C2FF),
            thickness: 2,
          ),
          SizedBox(height: 0), // 두 줄 사이의 간격
          Divider(
            color: Color(0xFF40C2FF),
            thickness: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentPageItems.length,
              itemBuilder: (context, index) {
                final chart = currentPageItems[index];
                final isSelected = selectedIndex == index;
                final globalIndex = startIndex + index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onChartSelected(chart);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF40C2FF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$globalIndex. [ ${chart['displayDate']} ${chart['displayTime']} ]',
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 18*(screenHeight/1200),
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
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_back_ios, color: Color(0xFF40C2FF),size: 40*(screenHeight/1040),),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_forward_ios, color: Color(0xFF40C2FF), size: 40*(screenHeight/1040)),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}