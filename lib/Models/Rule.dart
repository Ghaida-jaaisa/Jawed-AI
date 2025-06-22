import 'package:mobileapp/Models/Quiz.dart';

class Rule {
  final String name;
  final String definition;
  final List<String> examples;
  final String videoUrl;
  final List<Quiz> quiz;

  Rule({
    required this.name,
    required this.definition,
    required this.examples,
    required this.videoUrl,
    required this.quiz,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      name: json['name'] as String,
      definition: json['definition'] as String,
      examples: List<String>.from(json['examples'] as List),
      videoUrl: json['videoUrl'] as String,
      quiz:
          (json['quiz'] as List)
              .map((q) => Quiz.fromJson(q as Map<String, dynamic>))
              .toList(),
    );
  }
}