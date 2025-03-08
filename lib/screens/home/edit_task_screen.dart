import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedToController;
  late TextEditingController _clientNameController;
  late TextEditingController _clientDesignationController;
  late TextEditingController _clientEmailController;
  DateTime? _commencementDate;
  DateTime? _dueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = TextEditingController(text: widget.task.description);
    _assignedToController = TextEditingController(text: widget.task.assignedTo);
    _clientNameController = TextEditingController(text: widget.task.clientName);
    _clientDesignationController = TextEditingController(text: widget.task.clientDetails['designation']);
    _clientEmailController = TextEditingController(text: widget.task.clientDetails['email']);
    _commencementDate = DateFormat('yyyy-MM-dd').parse(widget.task.commencementDate);
    _dueDate = DateFormat('yyyy-MM-dd').parse(widget.task.dueDate);
  }

  // Update task in Firestore
  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedTask = Task(
          id: widget.task.id,
          name: _nameController.text,
          urn: widget.task.urn,
          description: _descriptionController.text,
          commencementDate: _commencementDate != null
              ? DateFormat('yyyy-MM-dd').format(_commencementDate!)
              : '',
          dueDate: _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : '',
          assignedTo: _assignedToController.text,
          assignedBy: widget.task.assignedBy,
          clientName: _clientNameController.text,
          clientDetails: {
            'name': _clientNameController.text,
            'designation': _clientDesignationController.text,
            'email': _clientEmailController.text,
          },
          status: widget.task.status, generalData: {}, schools: {},
        );

        // Update in Firestore
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.task.id)
            .update(updatedTask.toMap());

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task updated successfully!'),
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
      initialDate: _commencementDate ?? DateTime.now(),
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
      initialDate: _dueDate ?? DateTime.now(),
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
        title: Text('Edit Task'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Task Name Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
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
                  ),
                ),
                SizedBox(height: 20),

                // Task Description Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
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
                  ),
                ),
                SizedBox(height: 20),

                // Commencement Date Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
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
                  ),
                ),
                SizedBox(height: 20),

                // Due Date Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
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
                  ),
                ),
                SizedBox(height: 20),

                // Assigned To Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
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
                  ),
                ),
                SizedBox(height: 20),

                // Client Name Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
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
                  ),
                ),
                SizedBox(height: 20),

                // Client Details Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Update Button
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _updateTask,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue.shade700,
                        ),
                        child: Text(
                          'Update Task',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}