import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ฟังก์ชันสมัครสมาชิกแบบง่ายที่สุด
  void createAccountFunction() {
    String email = _emailController.text;
    String password = _passwordController.text;

    print('กำลังพยายามสร้างบัญชีด้วย Email: $email');

    // เรียกใช้ Firebase Auth เพื่อสร้างผู้ใช้
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((userCredential) {
      // --- ถ้าสำเร็จ ---
      print('สร้างบัญชีสำเร็จ! User UID: ${userCredential.user?.uid}');
      // กลับไปหน้าก่อนหน้า (หน้า Login)
      Navigator.pop(context);
    }).catchError((error) {
      // --- ถ้าไม่สำเร็จ ---
      print('เกิดข้อผิดพลาด: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: createAccountFunction, // เรียกใช้ฟังก์ชันที่เราสร้าง
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}