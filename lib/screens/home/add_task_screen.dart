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
        title: Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Task Name
                  _buildInputField(
                    controller: _nameController,
                    label: 'Task Name',
                    icon: Icons.task,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Task name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Task Description
                  _buildInputField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Commencement Date
                  _buildDatePicker(
                    label: 'Commencement Date',
                    value: _commencementDate != null
                        ? DateFormat('yyyy-MM-dd').format(_commencementDate!)
                        : 'Select Date',
                    onTap: _pickCommencementDate,
                  ),
                  SizedBox(height: 20),

                  // Due Date
                  _buildDatePicker(
                    label: 'Due Date',
                    value: _dueDate != null
                        ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                        : 'Select Date',
                    onTap: _pickDueDate,
                  ),
                  SizedBox(height: 20),

                  // Assigned To
                  _buildInputField(
                    controller: _assignedToController,
                    label: 'Assigned To',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Assigned To is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Client Name
                  _buildInputField(
                    controller: _clientNameController,
                    label: 'Client Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Client Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Client Details Section
                  Text(
                    'Client Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Client Designation
                  _buildInputField(
                    controller: _clientDesignationController,
                    label: 'Designation',
                    icon: Icons.work,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Designation is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  // Client Email
                  _buildInputField(
                    controller: _clientEmailController,
                    label: 'Email',
                    icon: Icons.email,
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
                            backgroundColor: Colors.blue.shade700,
                            elevation: 5,
                          ),
                          child: Text(
                            'Save Task',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  // Helper method to build date picker fields
  Widget _buildDatePicker({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          ),
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.blue.shade700),
        ),
      ),
    );
  }
}