import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('status', isEqualTo: 'Completed')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No completed tasks found.'));
          }

          final tasks = snapshot.data!.docs.map((doc) {
            return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
          print(tasks[0]);

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Text('URN: ${task.urn}'),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                  onTap: () {
                    _showTaskDetailsPopup(context, task);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Show task details in a popup
  void _showTaskDetailsPopup(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Task Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${task.name}'),
                SizedBox(height: 10),
                Text('URN: ${task.urn}'),
                SizedBox(height: 10),
                Text('Status: ${task.status}'),
                SizedBox(height: 10),
                Text('Area Name: ${task.generalData['areaName']}'),
                SizedBox(height: 10),
                Text('Total Schools: ${task.generalData['totalSchools']}'),
                SizedBox(height: 20),
                
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}