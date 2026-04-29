import 'package:flutter/material.dart';

class YesNoQuestionCard extends StatefulWidget {
  final String questionNumber;
  final String question;
  final String description;
  final ValueChanged<bool> onAnswer;

  const YesNoQuestionCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.description,
    required this.onAnswer,
  });

  @override
  State<YesNoQuestionCard> createState() => _YesNoQuestionCardState();
}

class _YesNoQuestionCardState extends State<YesNoQuestionCard> {
  bool? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // gradient: const LinearGradient(
        //   colors: [Color(0xff1E1E1E), Color(0xff111111)],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// QUESTION
          Text(
            "${widget.questionNumber}. ${widget.question}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          /// DESCRIPTION
          Text(
            widget.description,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          /// YES / NO BUTTONS
          Row(
            children: [
              _optionButton(
                label: "Yes",
                icon: Icons.check,
                value: true,
              ),
              const SizedBox(width: 14),
              _optionButton(
                label: "No",
                icon: Icons.close,
                value: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _optionButton({
    required String label,
    required IconData icon,
    required bool value,
  }) {
    final bool isSelected = selectedValue == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedValue = value);
          widget.onAnswer(value);
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xffFF4FD8)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
