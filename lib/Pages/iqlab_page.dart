import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class IqlabQuizPage extends StatefulWidget {
  @override
  _IqlabQuizPageState createState() => _IqlabQuizPageState();
}

class _IqlabQuizPageState extends State<IqlabQuizPage> {
  int qIndex = 0;
  int score = 0;

  final List<Map<String, dynamic>> quiz = [
    {
      'question': 'ما هو حكم الإقلاب؟',
      'options': [
        'تحويل النون الساكنة إلى ميم إذا جاء بعدها الباء',
        'نطق النون الساكنة بصوت واضح',
        'تحويل التنوين إلى ياء'
      ],
      'correctIndex': 0,
    },
    {
      'question': 'متى يحدث الإقلاب؟',
      'options': [
        'عند مجيء حرف الباء بعد النون الساكنة أو التنوين',
        'عند مجيء حرف الميم',
        'عند مجيء حرف الراء'],
      'correctIndex': 0,
    },
    {
      'question': 'هل الإقلاب يشمل تحويل التنوين إلى ميم؟',
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
      message = 'رائع! إجاباتك كلها صحيحة! 🌟';
    } else if (score == 0) {
      message = 'لا بأس، حاول مرة أخرى 💪';
    } else {
      message = 'أحسنت! نتيجتك: $score / ${quiz.length}';
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
        title: Text('اختبار الإقلاب'),
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

class IqlabPage extends StatelessWidget {
  final List<String> examples = [
    'أَنْبَتَكُمْ تُقرأ أَمْبَتَكُمْ',
    'مَنْ بَخِلَ تُقرأ مَمْ بَخِلَ',
    'خَبِيرًا بَصِيرًا تُقرأ خَبِيرَمْ بَصِيرًا',
    'يَوْمِئِذٍ بِبَنِيهِ تُقرأ يَوْمِئِذِمْ بِبَنِيهِ',
  ];

  final String videoUrl = 'https://youtu.be/5EhdiokFlbs?si=0dAdQfrXVThU-OXB';

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
        title: Text('حكم الإقلاب'),
        backgroundColor: Color(0xFF2FBAC4),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            tooltip: 'اختبر نفسك',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IqlabQuizPage()),
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
                  '📖 الإقلاب هو تحويل النون الساكنة أو التنوين إلى ميمٍ مخفاة إذا جاء بعدها حرف الباء',
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
            ...examples.map((example) => Card(
              child: ListTile(
                title: Text(
                  example,
                  textAlign: TextAlign.right,
                ),
              ),
            )),
            SizedBox(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: _openVideo,
                icon: Icon(Icons.video_library, color: Colors.teal),
                label: Text(
                  ' لمشاهدة شرح الإقلاب على يوتيوب، اضغطي هنا',
                  style: TextStyle(fontSize: 16, color: Colors.teal),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
