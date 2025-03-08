class Task {
  String? id; // Firestore document ID
  String name;
  String urn;
  String description;
  String commencementDate;
  String dueDate;
  String assignedTo;
  String assignedBy;
  String clientName;
  Map<String, String> clientDetails; // Client details (name, designation, email)
  String status;
  Map<String, dynamic> generalData; // General Data (areaName, totalSchools)
  Map<String, Map<String, dynamic>> schools; // Schools data

  Task({
    this.id,
    required this.name,
    required this.urn,
    required this.description,
    required this.commencementDate,
    required this.dueDate,
    required this.assignedTo,
    required this.assignedBy,
    required this.clientName,
    required this.clientDetails,
    required this.status,
    required this.generalData,
    required this.schools,
  });

  // Convert Task object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'urn': urn,
      'description': description,
      'commencementDate': commencementDate,
      'dueDate': dueDate,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'clientName': clientName,
      'clientDetails': clientDetails,
      'status': status,
      'generalData': generalData,
      'schools': schools,
    };
  }

  // Create a Task object from a Firestore document
  factory Task.fromMap(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      name: data['name'],
      urn: data['urn'],
      description: data['description'],
      commencementDate: data['commencementDate'],
      dueDate: data['dueDate'],
      assignedTo: data['assignedTo'],
      assignedBy: data['assignedBy'],
      clientName: data['clientName'],
      clientDetails: Map<String, String>.from(data['clientDetails']),
      status: data['status'],
      generalData: Map<String, dynamic>.from(data['generalData'] ?? {}),
      schools: Map<String, Map<String, dynamic>>.from(data['schools'] ?? {}),
    );
  }
}