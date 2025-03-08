import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/screens/home/task_commencement_screen.dart';

class GeneralDataScreen extends StatefulWidget {
  final String taskId;

  GeneralDataScreen({required this.taskId});

  @override
  _GeneralDataScreenState createState() => _GeneralDataScreenState();
}

class _GeneralDataScreenState extends State<GeneralDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaNameController = TextEditingController();
  int _totalSchools = 0;

  Future<void> _saveGeneralData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Save general data to Firestore
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .update({
          'generalData': {
            'areaName': _areaNameController.text,
            'totalSchools': _totalSchools,
          },
        });

        // Navigate to Task Commencement Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskCommencementScreen(
              taskId: widget.taskId,
              areaName: _areaNameController.text,
              totalSchools: _totalSchools,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Data'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Area Name
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _areaNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of the Area',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Area name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Total Number of Schools
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<int>(
                    value: _totalSchools,
                    decoration: InputDecoration(
                      labelText: 'Total Number of Schools',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(6, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text('$index'),
                      );
                    },
                   
                  ), onChanged: (value) {
                      setState(() {
                        _totalSchools = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Please select the number of schools';
                      }
                      return null;
                    },
                ),
              ),),
              SizedBox(height: 20),

              // Proceed Button
              ElevatedButton(
                onPressed: _saveGeneralData,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue.shade700,
                ),
                child: Text(
                  'Proceed',
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