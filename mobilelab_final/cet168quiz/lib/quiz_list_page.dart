import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cet168quiz/add_edit_quiz_page.dart';
import 'package:cet168quiz/take_quiz_page.dart'; // <-- ตรวจสอบว่ามี import นี้
import 'package:flutter/material.dart';

class QuizListPage extends StatelessWidget {
  final bool isAdmin;
  const QuizListPage({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Manage Quizzes' : 'Available Quizzes'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No quizzes found.'));
          }

          final quizzes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quizDoc = quizzes[index];
              final quizData = quizDoc.data() as Map<String, dynamic>;
              final title = quizData['title'] ?? 'No Title';
              final description = quizData['description'] ?? 'No Description';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: isAdmin ? Icon(Icons.edit) : null,
                  // --- จุดที่ต้องแก้ไข ---
                  onTap: () {
                    if (isAdmin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditQuizPage(quizDoc: quizDoc),
                        ),
                      );
                    } else {
                      // ส่งผู้ใช้ไปหน้าทำข้อสอบ พร้อมกับ ID ของ Quiz
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakeQuizPage(quizId: quizDoc.id),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditQuizPage()),
                );
              },
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}