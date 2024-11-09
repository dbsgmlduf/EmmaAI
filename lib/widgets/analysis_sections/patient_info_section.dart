import 'package:flutter/material.dart';
import '../../models/patient_data.dart';

class PatientInfoSection extends StatelessWidget {
  final Patient? patient;

  const PatientInfoSection({this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF40C2FF), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('User ID: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 18)),
                  Text(patient?.id ?? '', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Date: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 18)),
                  Text(patient?.date ?? '', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Sex: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 18)),
                  Text(patient?.sex ?? '', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Age: ', style: TextStyle(color: Color(0xFF40C2FF), fontSize: 18)),
                  Text(patient?.age?.toString() ?? '', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
} 