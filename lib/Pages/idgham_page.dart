import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IdghamPage extends StatefulWidget {
  static const String routeName = '/IdghamPage';

  @override
  _IdghamPageState createState() => _IdghamPageState();
}

class _IdghamPageState extends State<IdghamPage> {
  Map<String, dynamic>? ruleData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRuleData();
  }

  Future<void> fetchRuleData() async {
    final response = await http.get(Uri.parse('http://jawedai.runasp.net/Home/GetRule/1'));
    if (response.statusCode == 200) {
      setState(() {
        ruleData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }

  Future<void> _openVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح الرابط';
    }
  }

  void _startQuiz() {
    if (ruleData == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(quiz: ruleData!["quiz"]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حكم الإدغام'),
        backgroundColor: Color(0xFF2FBAC4),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            tooltip: 'اختبر نفسك',
            onPressed: _startQuiz,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '📖 ' + (ruleData!["definition"] ?? ""),
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '📝 أمثلة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            ...List.generate(ruleData!["examples"].length, (index) {
              return Card(
                child: ListTile(
                  title: Text(
                    ruleData!["examples"][index],
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            }),
            SizedBox(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: () => _openVideo(ruleData!["videoUrl"]),
                icon: Icon(Icons.video_library, color: Colors.teal),
                label: Text(
                  ' لمشاهدة شرح الإدغام على يوتيوب، اضغط هنا',
                  style: TextStyle(fontSize: 16, color: Colors.teal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final List<dynamic> quiz;

  QuizPage({required this.quiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int qIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showQuizDialog();
    });
  }

  void _showQuizDialog() {
    if (qIndex >= widget.quiz.length) {
      _showResult();
      return;
    }

    final currentQ = widget.quiz[qIndex];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('سؤال ${qIndex + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentQ['question']),
            SizedBox(height: 10),
            ...List.generate(currentQ['options'].length, (i) {
              return ListTile(
                title: Text(currentQ['options'][i]),
                onTap: () {
                  if (i == currentQ['correctIndex']) score++;
                  Navigator.pop(context);
                  setState(() => qIndex++);
                  _showQuizDialog();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showResult() {
    String message;
    if (score == widget.quiz.length) {
      message = 'رائع! إجاباتك كلها صحيحة! 🌟';
    } else if (score == 0) {
      message = 'لا بأس، حاول مرة أخرى 💪';
    } else {
      message = 'أحسنت! نتيجتك: $score / ${widget.quiz.length}';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('نتيجتك🎉'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                qIndex = 0;
                score = 0;
              });
              Navigator.pop(context);
              _showQuizDialog();
            },
            child: Text('إعادة'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختبار الإدغام'),
        backgroundColor: Color(0xFF2FBAC4),
      ),
    );
  }
}
