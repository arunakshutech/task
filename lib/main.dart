import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:task/firebase_options.dart';
import 'package:task/screens/auth/%20signup_screen.dart';
import 'package:task/screens/auth/forgot_password_screen.dart';
import 'package:task/screens/home/Heildtask.dart';
import 'package:task/screens/home/add_task_screen.dart';
import 'package:task/screens/home/edit_task_screen.dart';
import 'package:task/screens/home/home_screen.dart';
import 'package:task/services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'providers/task_provider.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ Ensure this is present
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
         '/signup': (context) => SignUpScreen(),
        '/add_task': (context) => AddTaskScreen(),
        '/Passwordreset': (context) => ForgetPasswordScreen(),
        '/Heildtask': (context) => Heildtask(),
       
      },
    );
  }
}