import 'package:flutter/material.dart';
import 'package:inflammation/dialog/alert_list_dialog.dart';
import 'package:inflammation/dialog/alert_delete_dialog.dart';
import '../../models/patient_data.dart';
import '../../services/patient_service.dart';

class PatientListHeader extends StatefulWidget {
  final String licenseKey;
  final List<Patient> patients;
  final String? selectedPatientId;
  final Function(String) onPatientDeleted;
  final Function(Patient) onPatientSelected;
  final VoidCallback onPatientsUpdated;

  const PatientListHeader({
    required this.licenseKey,
    required this.patients,
    required this.selectedPatientId,
    required this.onPatientDeleted,
    required this.onPatientSelected,
    required this.onPatientsUpdated,
  });

  @override
  _PatientListHeaderState createState() => _PatientListHeaderState();
}

class _PatientListHeaderState extends State<PatientListHeader> {
  bool _isSearchActive = false;
  TextEditingController _searchController = TextEditingController();

  void _filterPatients(String query) {
    if (query.isEmpty) return;
    
    final filteredPatients = widget.patients.where((patient) {
      return patient.id.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredPatients.isNotEmpty) {
      widget.onPatientSelected(filteredPatients[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isSearchActive)
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search patient by ID',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF40C2FF)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Color(0xFF40C2FF)),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _isSearchActive = false;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF40C2FF)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF40C2FF), width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _filterPatients,
                onSubmitted: _filterPatients,
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.search, color: Color(0xFF40C2FF)),
              onPressed: () => setState(() => _isSearchActive = true),
            ),
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFF40C2FF)),
            onPressed: () async {
              await showAddPatientDialog(
                context,
                widget.licenseKey,
                widget.onPatientsUpdated,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Color(0xFF40C2FF)),
            onPressed: widget.selectedPatientId != null
              ? () async {
                  await showDeleteConfirmationDialog(
                    context,
                    widget.selectedPatientId!,
                    widget.licenseKey,
                    () async {
                      await widget.onPatientDeleted(widget.selectedPatientId!);
                      widget.onPatientsUpdated();
                    },
                  );
                }
              : null,
          ),
        ],
      ),
    );
  }
}