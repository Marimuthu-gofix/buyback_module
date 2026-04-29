import 'package:flutter/material.dart';

class ProblemGridCard extends StatelessWidget {
  final Map<String, String> options; // label -> icon
  final Set<String> selectedItems;
  final Function(String) onToggle;

  const ProblemGridCard({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (_, index) {
        final label = options.keys.elementAt(index);
        final icon = options.values.elementAt(index);
        final isSelected = selectedItems.contains(label);

        return GestureDetector(
          onTap: () => onToggle(label),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xffFF4FD8)
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  height: 90,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isSelected
                        ? const Color(0xffFF4FD8)
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
