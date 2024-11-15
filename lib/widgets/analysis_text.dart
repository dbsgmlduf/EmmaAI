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
  int _selectedIndex = -1;
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final int totalPages = (widget.chartHistory.length / _itemsPerPage).ceil();
    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < widget.chartHistory.length) 
        ? startIndex + _itemsPerPage 
        : widget.chartHistory.length;

    return Container(
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HISTORY',
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
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: endIndex - startIndex,
                    itemBuilder: (context, index) {
                      final historyIndex = startIndex + index;
                      return Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: ListTile(
                          title: Text(
                            '${historyIndex + 1}. [${widget.chartHistory[historyIndex]['date']}]',
                            style: TextStyle(color: Colors.white),
                          ),
                          selected: _selectedIndex == historyIndex,
                          onTap: () {
                            setState(() {
                              _selectedIndex = historyIndex;
                            });
                            widget.onChartSelected(widget.chartHistory[historyIndex]);
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Color(0xFF40C2FF)),
                        onPressed: _currentPage > 0
                            ? () => setState(() => _currentPage--)
                            : null,
                      ),
                      Text(
                        '${_currentPage + 1} / $totalPages',
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Color(0xFF40C2FF)),
                        onPressed: _currentPage < totalPages - 1
                            ? () => setState(() => _currentPage++)
                            : null,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}