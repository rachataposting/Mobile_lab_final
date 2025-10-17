import 'package:flutter/material.dart';

// ทำให้แน่ใจว่า class ของเราสืบทอดคุณสมบัติมาจาก StatelessWidget
class ResultPage extends StatelessWidget {
  // ตัวแปรสำหรับรับค่าคะแนนและจำนวนข้อทั้งหมด
  final int score;
  final int totalQuestions;

  // Constructor เพื่อรับค่าเข้ามา
  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Result'),
        automaticallyImplyLeading: false, // เอาปุ่ม back ออก
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กลางจอ
          children: [
            Text(
              'Your Score',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // แสดงผลคะแนนที่ได้รับมา
            Text(
              '$score / $totalQuestions',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            // ปุ่มกลับหน้าแรก
            ElevatedButton(
              onPressed: () {
                // กลับไปยังหน้าแรกสุดของแอป (หน้ารายการ Quiz)
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}