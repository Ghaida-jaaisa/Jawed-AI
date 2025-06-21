import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IdhharQuizPage extends StatefulWidget {
  @override
  _IdhharQuizPageState createState() => _IdhharQuizPageState();
}

class _IdhharQuizPageState extends State<IdhharQuizPage> {
  int qIndex = 0;
  int score = 0;

  final List<Map<String, dynamic>> quiz = [
    {
      'question': 'ما هو حكم الإظهار؟',
      'options': [
        'إخراج الحرف من مخرجه من غير غنة',
        'تحويل النون الساكنة إلى ميم',
        'الإدغام مع الغنة',
      ],
      'correctIndex': 0,
    },
    {
      'question': 'كم عدد حروف الإظهار؟',
      'options': ['6', '15', '10'],
      'correctIndex': 0,
    },
    {
      'question': 'هل الإظهار يحدث قبل الحروف (ء، هـ، ع، ح، غ، خ)؟',
      'options': ['نعم', 'لا'],
      'correctIndex': 0,
    },
  ];

  void _showQuizDialog() {
    if (qIndex >= quiz.length) {
      _showResult();
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        final currentQ = quiz[qIndex];

        return AlertDialog(
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
        );
      },
    );
  }

  void _showResult() {
    String message;

    if (score == quiz.length) {
      message = 'ممتاز! جميع إجاباتك صحيحة! 🎉';
    } else if (score == 0) {
      message = 'لا تقلق، حاول مرة أخرى 💪';
    } else {
      message = 'أحسنت! نتيجتك: $score / ${quiz.length}';
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
        title: Text('اختبار الإظهار'),
        backgroundColor: Color(0xFF2FBAC4),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('ابدأ الاختبار'),
          onPressed: _showQuizDialog,
        ),
      ),
    );
  }
}

class IdhharPage extends StatelessWidget {
  static const String routeName = '/IdhharPage';

  final List<String> examples = [
    'من آمن',
    'أنعمت',
    'فريقًا هدى',
    'يومئذٍ خاشعةً',
  ];

  final String videoUrl = 'https://youtu.be/Fkd0NIjUkQs?si=OSKFd7f1Rht9u9h1';

  Future<void> _openVideo() async {
    final Uri url = Uri.parse(videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح الرابط';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF2FBAC4),
      appBar: AppBar(
        title: Text('حكم الإظهار'),
        backgroundColor: Color(0xFF2FBAC4),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            tooltip: 'اختبر نفسك',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IdhharQuizPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '📖 الإظهار هو إخراج الحرف من مخرجه من غير غنة، ويكون إذا جاءت نون ساكنة أو تنوين قبل أحد الحروف الستة (ء، هـ، ع، ح، غ، خ)',
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
            ...examples.map(
              (example) => Card(
                child: ListTile(
                  title: Text(example, textAlign: TextAlign.right),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: _openVideo,
                icon: Icon(Icons.video_library, color: Colors.teal),
                label: Text(
                  ' لمشاهدة شرح الإظهار على يوتيوب، اضغط هنا',
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