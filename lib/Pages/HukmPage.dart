import 'package:flutter/material.dart';
import 'package:mobileapp/Models/Rule.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HukmPage extends StatefulWidget {
  HukmPage({Key? key}) : super(key: key);
  static const String routeName = '/HukmPage';

  @override
  State<HukmPage> createState() => _HukmPageState();
}

class _HukmPageState extends State<HukmPage> {
  int ruleId = 0;
  int qIndex = 0;
  int score = 0;
  Rule? rule;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ruleId = ModalRoute.of(context)!.settings.arguments as int;
    fetchRuleData(ruleId);
  }

  Future<void> fetchRuleData(int id) async {
    final url = Uri.parse('http://jawedai.runasp.net/Home/GetRule/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        rule = Rule.fromJson(json.decode(response.body));
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'فشل في تحميل البيانات (status ${response.statusCode})',
          ),
        ),
      );
      setState(() => isLoading = false);
    }
  }

  void _showQuizDialog() {
    // if we've shown all questions, show result
    if (qIndex >= rule!.quiz.length) {
      _showResult();
      return;
    }

    final currentQ = rule!.quiz[qIndex];

    showDialog(
      context: context,
      barrierDismissible: true, // ← now tapping outside will dismiss
      builder:
          (_) => AlertDialog(
            title: Text('سؤال ${qIndex + 1}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentQ.question),
                SizedBox(height: 10),
                ...List.generate(currentQ.options.length, (i) {
                  return ListTile(
                    title: Text(currentQ.options[i]),
                    onTap: () {
                      // increment score if correct
                      if (i == currentQ.correctIndex) score++;
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
    if (score == rule!.quiz.length) {
      message = 'رائع! إجاباتك كلها صحيحة! 🌟';
    } else if (score == 0) {
      message = 'لا بأس، حاول مرة أخرى 💪';
    } else {
      message = 'أحسنت! نتيجتك: $score / ${rule!.quiz.length}';
    }

    showDialog(
      context: context,
      barrierDismissible: true, // ← now tapping outside will dismiss
      builder:
          (_) => AlertDialog(
            title: Text('نتيجتك 🎉'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  // reset and restart
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
        title: Text(rule?.name ?? 'تحميل...'),
        backgroundColor: Color(0xFF2FBAC4),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            tooltip: 'اختبر نفسك',
            onPressed: _showQuizDialog,
            color: Colors.white,
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : rule == null
              ? Center(child: Text('لا توجد بيانات'))
              : Padding(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          '📖 ${rule!.definition}',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '📝 أمثلة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    ...rule!.examples.map(
                      (ex) => Card(
                        child: ListTile(
                          title: Text(ex, textAlign: TextAlign.right),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}