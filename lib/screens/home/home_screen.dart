import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/screens/auth/login_screen.dart';
import 'package:task/screens/home/CompletedTask.dart';
import 'package:task/screens/home/generaldata.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'task_commencement_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.loadTasks(); // ✅ Load tasks outside build()
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
   

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          // User button with dropdown menu
          PopupMenuButton<String>(
            icon: Icon(Icons.person_2_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'settings') {
                // Navigate to settings screen
              } else if (value == 'signout') {
                // Handle sign out
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'home', child: Text('Home')),
                  PopupMenuItem(value: 'settings', child: Text('Settings')),
                  PopupMenuItem(
                    value: 'signout',
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      child: Text("sign out "),
                    ),
                  ),
                ],
          ),
        ],
      ),
      drawer: _buildSidebar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_task');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.blue.shade600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add Task', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          // Dashboard
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 31, 34, 79),
                ),
                headingTextStyle: TextStyle(color: Colors.white),
                dividerThickness: 4,
                columnSpacing: 42,
                columns: [
                  DataColumn(
                    label: Text(
                      'URN',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Task Name',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Assigned By',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Assigned To',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Commencement Date',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Due Date',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Client Name',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
                rows:
                    taskProvider.tasks.map((task) {
                      return DataRow(
                        cells: [
                          DataCell(Text(task.urn)),
                          DataCell(Text(task.name)),
                          DataCell(Text(task.assignedBy)),
                          DataCell(Text(task.assignedTo)),
                          DataCell(Text(task.commencementDate)),
                          DataCell(Text(task.dueDate)),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                _showClientDetails(
                                  context,
                                  task.clientName,
                                  task.clientDetails['designation'].toString(),
                                  task.clientDetails['email'].toString(),
                                );
                              },
                              child: Text(
                                task.clientName,
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(task.status)),
                          DataCell(
                            Row(
                              children: [
                                // Start button
                                IconButton(
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.blue.shade700,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => GeneralDataScreen(
                                              taskId: task.id.toString(),
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                // Edit button
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue.shade700,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                EditTaskScreen(task: task),
                                      ),
                                    );
                                  },
                                ),
                                // Delete button
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    taskProvider.moveTaskToWithheld(task.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the sidebar
  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: Text(
              'Task Manager',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.schedule, color: Colors.blue.shade700),
            title: Text('Scheduled Tasks'),
            onTap: () {
              // Navigate to scheduled tasks
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.done, color: Colors.blue.shade700),
            title: Text('Completed Tasks'),
            onTap: () {
              // Navigate to completed tasks
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CompletedTasksScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.archive, color: Colors.blue.shade700),
            title: Text('With-held Tasks'),
            onTap: () {
              
              Navigator.pushNamed(context, '/Heildtask');
            },
          ),
        ],
      ),
    );
  }

  // Show client details popup
  void _showClientDetails(
    BuildContext context,
    String clientName,
    String designation,
    String email,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Client Details',
            style: TextStyle(color: Colors.blue.shade700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue.shade700),
                title: Text('Name: $clientName'),
              ),
              ListTile(
                leading: Icon(Icons.work, color: Colors.blue.shade700),
                title: Text('Designation: $designation'),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue.shade700),
                title: Text('Email: $email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.blue.shade700),
              ),
            ),
          ],
        );
      },
    );
  }
}
