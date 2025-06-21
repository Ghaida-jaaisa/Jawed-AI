import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IkhfaQuizPage extends StatefulWidget {
  @override
  _IkhfaQuizPageState createState() => _IkhfaQuizPageState();
}

class _IkhfaQuizPageState extends State<IkhfaQuizPage> {
  int qIndex = 0;
  int score = 0;

  final List<Map<String, dynamic>> quiz = [
    {
      'question': 'هل الإخفاء هو نطق النون الساكنة بصوت خفيف؟',
      'options': ['نعم', 'لا'],
      'correctIndex': 0,
    },
    {
      'question': 'كم عدد حروف الإخفاء؟',
      'options': ['15', '10', '7'],
      'correctIndex': 0,
    },
    {
      'question': 'الإخفاء هو النطق بالنون الساكنة بصوت واضح مثل الإظهار.',
      'options': ['صح', 'خطأ'],
      'correctIndex': 1,
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
        title: Text('اختبار الإخفاء'),
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

class IkhfaPage extends StatelessWidget {
  static const String routeName = '/IkhfaPage';

  final List<String> examples = [
    'مِنْ فَوْقِ',
    'أَزْوَاجًا ثَلاثَةً',
    'أنْعم',
    'ريحًا صرصرًاً',
  ];

  final String videoUrl = 'https://youtu.be/RNXcTbJsWo4?si=fOQMTlTstNb4wKSQ';

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
        title: Text('حكم الإخفاء'),
        backgroundColor: Color(0xFF2FBAC4),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            tooltip: 'اختبر نفسك',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IkhfaQuizPage()),
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
                  '📖 الإخفاء هو النطق بالنون الساكنة أو التنوين بصوتٍ خفيف بين الإظهار والإدغام، ويحدث عند مجيء أحد حروف الإخفاء (15 حرفًا)',
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
                  ' لمشاهدة شرح الإخفاء على يوتيوب، اضغطي هنا',
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