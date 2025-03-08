import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientDesignationController = TextEditingController();
  final _clientEmailController = TextEditingController();
  DateTime? _commencementDate;
  DateTime? _dueDate;
  bool _isLoading = false;

  // Generate a random URN
  String _generateURN() {
    return 'URN-${DateTime.now().millisecondsSinceEpoch}';
  }

  // Save task to Firestore
  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('User not logged in');
        }

        final task = Task(
          id: null,
          name: _nameController.text,
          urn: _generateURN(),
          description: _descriptionController.text,
          commencementDate: _commencementDate != null
              ? DateFormat('yyyy-MM-dd').format(_commencementDate!)
              : '',
          dueDate: _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : '',
          assignedTo: _assignedToController.text,
          assignedBy: user.email ?? 'Admin',
          clientName: _clientNameController.text,
          clientDetails: {
            'name': _clientNameController.text,
            'designation': _clientDesignationController.text,
            'email': _clientEmailController.text,
          },
          status: 'Scheduled', generalData: {}, schools: {},
        );

        // Save to Firestore
        await FirebaseFirestore.instance.collection('tasks').add(task.toMap());

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show date picker for commencement date
  Future<void> _pickCommencementDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _commencementDate = pickedDate;
      });
    }
  }

  // Show date picker for due date
  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Task Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Task name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Task Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Commencement Date
                InkWell(
                  onTap: _pickCommencementDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Commencement Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _commencementDate != null
                          ? DateFormat('yyyy-MM-dd').format(_commencementDate!)
                          : 'Select Date',
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Due Date
                InkWell(
                  onTap: _pickDueDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _dueDate != null
                          ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                          : 'Select Date',
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Assigned To
                TextFormField(
                  controller: _assignedToController,
                  decoration: InputDecoration(
                    labelText: 'Assigned To',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Assigned To is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Client Name
                TextFormField(
                  controller: _clientNameController,
                  decoration: InputDecoration(
                    labelText: 'Client Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Client Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Client Details Table
                Text(
                  'Client Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _clientDesignationController,
                  decoration: InputDecoration(
                    labelText: 'Designation',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Designation is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _clientEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Save Button
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveTask,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Save Task'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}