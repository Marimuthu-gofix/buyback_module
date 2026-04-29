class ConditionQuestion {
  final int id;
  final String question;
  final String description;
  bool? answer; // true = Yes, false = No, null = not answered

  ConditionQuestion({
    required this.id,
    required this.question,
    required this.description,
    this.answer,
  });

  // Optional: Convert to JSON (useful later for API)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "description": description,
      "answer": answer,
    };
  }
}

class ConditionData {
  static List<ConditionQuestion> questions = [
    ConditionQuestion(
      id: 1,
      question: "Is the phone in proper working condition?",
      description:
          "Check if the phone powers on and confirm that it is in working condition",
    ),
    ConditionQuestion(
      id: 2,
      question: "Is the touchscreen on your phone working properly?",
      description: "Check the touch screen functionality of your phone",
    ),
    ConditionQuestion(
      id: 3,
      question: "Is the phone’s display original?",
      description:
          "Select 'Yes' if the screen was never changed or was changed by the Authorized Service Center. Select 'No' if the screen was changed at a local shop or UnAuthorized Service Center",
    ),
    ConditionQuestion(
      id: 4,
      question: "Is there a valid warranty for your phone?",
      description:
          "You'll get a better price if your device has a manufacturer warranty",
    ),
  ];
}
