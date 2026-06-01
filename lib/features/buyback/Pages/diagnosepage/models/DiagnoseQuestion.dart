class DiagnoseQuestion {
  final String questionName;
  final String questionText;

  DiagnoseQuestion({
    required this.questionName,
    required this.questionText,
  });

  factory DiagnoseQuestion.fromJson(Map<String, dynamic> json) {
    return DiagnoseQuestion(
      questionName: json['QuestionName'] ?? '',
      questionText: json['QuestionText'] ?? '',
    );
  }
}