import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cet168quiz/result_page.dart'; // <-- เพิ่ม import
import 'package:flutter/material.dart';

class TakeQuizPage extends StatefulWidget {
  final String quizId;
  const TakeQuizPage({super.key, required this.quizId});

  @override
  _TakeQuizPageState createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> {
  List<DocumentSnapshot> questions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  
  // 1. เพิ่มตัวแปรสำหรับเก็บคะแนน
  int score = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quizId)
        .collection('questions')
        .get();
    setState(() {
      questions = snapshot.docs;
    });
  }

  // 2. อัปเกรดฟังก์ชัน _nextQuestion
  void _nextQuestion() {
    // ตรวจคำตอบ
    final correctAnswer = questions[currentQuestionIndex].get('correctAnswer');
    if (selectedAnswer == correctAnswer) {
      // ถ้าตอบถูก ให้เพิ่มคะแนน
      score++;
    }

    // ไปข้อถัดไป หรือไปยังหน้าผลลัพธ์
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null; // รีเซ็ตคำตอบ
      });
    } else {
      // สิ้นสุด Quiz, ไปยังหน้าแสดงผล
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: score,
            totalQuestions: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final questionData = questions[currentQuestionIndex].data() as Map<String, dynamic>;
    final options = List<String>.from(questionData['options'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz ${currentQuestionIndex + 1}/${questions.length}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questionData['questionText'] ?? 'No question text',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ...options.map((option) {
              return Card(
                color: selectedAnswer == option ? Colors.indigo.shade100 : Colors.white,
                child: ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      selectedAnswer = option;
                    });
                  },
                ),
              );
            }).toList(),
            Spacer(),
            ElevatedButton(
              onPressed: selectedAnswer == null ? null : _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}