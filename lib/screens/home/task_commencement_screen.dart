import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TaskCommencementScreen extends StatefulWidget {
  final String taskId;
  final String areaName;
  final int totalSchools;

  TaskCommencementScreen({
    required this.taskId,
    required this.areaName,
    required this.totalSchools,
  });

  @override
  _TaskCommencementScreenState createState() => _TaskCommencementScreenState();
}

class _TaskCommencementScreenState extends State<TaskCommencementScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Commencement'),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: _buildSidebar(),
      body: _selectedIndex == 0
          ? GeneralDataOverview(areaName: widget.areaName, totalSchools: widget.totalSchools)
          : SchoolDataOverview(
              taskId: widget.taskId,
              schoolIndex: _selectedIndex - 1,
            ),
    );
  }

  // Build the sidebar
  Widget _buildSidebar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: Text(
              'Task Commencement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.data_usage, color: Colors.blue.shade700),
            title: Text('General Data'),
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          for (int i = 1; i <= widget.totalSchools; i++)
            ListTile(
              leading: Icon(Icons.school, color: Colors.blue.shade700),
              title: Text('School-$i'),
              onTap: () {
                setState(() {
                  _selectedIndex = i;
                });
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

class GeneralDataOverview extends StatelessWidget {
  final String areaName;
  final int totalSchools;

  GeneralDataOverview({required this.areaName, required this.totalSchools});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Area Name: $areaName',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Total Schools: $totalSchools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SchoolDataOverview extends StatefulWidget {
  final String taskId;
  final int schoolIndex;

  const SchoolDataOverview({required this.taskId, required this.schoolIndex});

  @override
  // ignore: library_private_types_in_public_api
  _SchoolDataOverviewState createState() => _SchoolDataOverviewState();
}

class _SchoolDataOverviewState extends State<SchoolDataOverview> {
  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController();
  String? _schoolType;
  final List<String> _curriculum = [];
  DateTime? _establishedDate;
  final List<String> _grades = [];

  Future<void> _saveSchoolData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Save school data to Firestore
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .collection('schools')
            .doc('school-${widget.schoolIndex + 1}')
            .set({
          'name': _schoolNameController.text,
          'type': _schoolType,
          'curriculum': _curriculum,
          'establishedOn': _establishedDate != null
              ? DateFormat('yyyy-MM-dd').format(_establishedDate!)
              : null,
          'grades': _grades,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('School data saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markTaskAsCompleted() async {
    try {
      // Update task status to "Completed"
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'status': 'Completed',
      });

      // Navigate back to the home screen
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route)=>false);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // School Name
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _schoolNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of the School',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'School name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // School Type
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: _schoolType,
                    decoration: InputDecoration(
                      labelText: 'Type of the School',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Public', 'Private', 'Govt Aided', 'Special']
                        .map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _schoolType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'School type is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
            
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Curriculum',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: ['CBSE', 'ICSE', 'IB', 'State Board'].map((curriculum) {
                          return FilterChip(
                            label: Text(curriculum),
                            selected: _curriculum.contains(curriculum),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _curriculum.add(curriculum);
                                } else {
                                  _curriculum.remove(curriculum);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Established On
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _establishedDate = pickedDate;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Established On',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _establishedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_establishedDate!)
                            : 'Select Date',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Grades (Multiple Selection)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grades Present',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: ['Primary', 'Secondary', 'Higher Secondary'].map((grade) {
                          return FilterChip(
                            label: Text(grade),
                            selected: _grades.contains(grade),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _grades.add(grade);
                                } else {
                                  _grades.remove(grade);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Save School Data Button
              ElevatedButton(
                onPressed: _saveSchoolData,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue.shade700,
                ),
                child: Text(
                  'Save School Data',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Finish Button
              ElevatedButton(
                onPressed: _markTaskAsCompleted,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Finish',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}