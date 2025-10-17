import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditQuizPage extends StatefulWidget {
  // 1. เพิ่มตัวแปรเพื่อรับข้อมูล Quiz ที่จะแก้ไข (อาจเป็น null ถ้าเป็นการสร้างใหม่)
  final DocumentSnapshot? quizDoc;

  // 2. แก้ไข Constructor ให้รับค่า quizDoc
  const AddEditQuizPage({super.key, this.quizDoc});

  @override
  _AddEditQuizPageState createState() => _AddEditQuizPageState();
}

class _AddEditQuizPageState extends State<AddEditQuizPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // 3. ใช้ initState() เพื่อตั้งค่าเริ่มต้นให้ฟอร์ม (ถ้าเป็นการแก้ไข)
  @override
  void initState() {
    super.initState();
    // ถ้ามีข้อมูล quizDoc ถูกส่งเข้ามา (เป็นการแก้ไข)
    if (widget.quizDoc != null) {
      // นำข้อมูลเก่ามาใส่ในช่องกรอก
      final data = widget.quizDoc!.data() as Map<String, dynamic>;
      _titleController.text = data['title'] ?? '';
      _descriptionController.text = data['description'] ?? '';
    }
  }

  // 4. แก้ไขฟังก์ชัน saveQuiz ให้รองรับทั้งการสร้างใหม่และการอัปเดต
  Future<void> saveQuiz() async {
    if (_titleController.text.isEmpty) return;

    final quizData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    try {
      if (widget.quizDoc == null) {
        // --- กรณีสร้างใหม่ ---
        await FirebaseFirestore.instance.collection('quizzes').add(quizData);
        print('สร้าง Quiz ใหม่สำเร็จ!');
      } else {
        // --- กรณีอัปเดตของเดิม ---
        await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizDoc!.id) // ระบุ ID ของเอกสารที่จะอัปเดต
            .update(quizData);
        print('อัปเดต Quiz สำเร็จ!');
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 5. เปลี่ยน Title ของหน้าตามสถานะ
        title: Text(widget.quizDoc == null ? 'Add Quiz' : 'Edit Quiz'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // ... ส่วน UI อื่นๆ เหมือนเดิม ...
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quiz Details', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              Divider(height: 40, thickness: 1),
              Text('Questions', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              Container( /* ... */ ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveQuiz,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: Icon(Icons.save),
      ),
    );
  }
}