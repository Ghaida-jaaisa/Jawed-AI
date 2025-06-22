class Quiz {
  final String question;
  final List<String> options;
  final int correctIndex;

  Quiz({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
    );
  }
}