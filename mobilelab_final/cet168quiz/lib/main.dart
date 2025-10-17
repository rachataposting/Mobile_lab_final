import 'package:cet168quiz/create_account_page.dart';
import 'package:cet168quiz/quiz_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CET Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // --- ส่วน Admin ---
    if (email == 'admin' && password == 'admin') {
      print('Admin กำลังเข้าระบบ...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboardPage()),
      );
      return;
    }

    // --- ส่วน User ทั่วไป ---
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login สำเร็จ!');
      // --- แก้ไข: ส่งผู้ใช้ทั่วไปไปที่ QuizListPage ---
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizListPage(isAdmin: false)),
      );
    } on FirebaseAuthException catch (e) {
      print('Login ไม่สำเร็จ: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... ส่วน UI ของ LoginPage (ไม่มีการแก้ไข) ...
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'CET QUIZ 168',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Sign in to continue', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                SizedBox(height: 48),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'ID or Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAccountPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.indigo),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Create account'),
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

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ... ส่วน UI ของ Dashboard (ไม่มีการแก้ไข) ...
            Row(
              children: [
                Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(children: [Text('Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('128', style: TextStyle(fontSize: 24))])))),
                SizedBox(width: 16),
                Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(children: [Text('Quizzes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('24', style: TextStyle(fontSize: 24))])))),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text('Manage Quizzes'),
              subtitle: Text('Create, edit, delete'),
              // --- แก้ไข: ส่งค่า isAdmin: true ไปยัง QuizListPage ---
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizListPage(isAdmin: true)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('View Statistics'),
              subtitle: Text('Scores and performance'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}