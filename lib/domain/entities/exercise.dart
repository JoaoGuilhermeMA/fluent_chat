class Exercise {
  final String id;
  final String type; // Ex: vocabulary, grammar, listening
  final String question;
  final String correctAnswer;
  final List<String> options;

  Exercise({
    required this.id,
    required this.type,
    required this.question,
    required this.correctAnswer,
    required this.options,
  });
}
