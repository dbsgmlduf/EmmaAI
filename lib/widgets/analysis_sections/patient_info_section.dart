import 'package:flutter/material.dart';
import '../../models/patient_data.dart';

class PatientInfoSection extends StatelessWidget {
  final Patient? patient;

  const PatientInfoSection({this.patient});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = 22 * (screenHeight / 1200);
    
    return Container(
      width: MediaQuery.of(context).size.width * (320/1920),
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
          Expanded(
            child: Row(
              children: [
                Text('User ID: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)),
                Flexible(
                  child: Text(patient?.id ?? '', 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: fontSize)
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text('Date: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)),
                Flexible(
                  child: Text(patient?.date ?? '', 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: fontSize)
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text('Sex: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)),
                Flexible(
                  child: Text(patient?.sex ?? '', 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: fontSize)
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text('Age: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: fontSize)),
                Flexible(
                  child: Text(patient?.age?.toString() ?? '', 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: fontSize)
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