import 'package:flutter/material.dart';

class OptionGridCard extends StatelessWidget {
  final String title;

  /// Option label → image path
  final Map<String, String> options;

  final String? selectedValue;
  final Function(String) onSelect;

  const OptionGridCard({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),

        /// GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, index) {
            final optionLabel = options.keys.elementAt(index);
            final imagePath = options.values.elementAt(index);
            final isSelected = selectedValue == optionLabel;

            return GestureDetector(
              onTap: () => onSelect(optionLabel),
              child: Container(
                padding: const EdgeInsets.all(12),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// PNG ICON
                    Image.asset(
                      imagePath,
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),

                    /// LABEL
                    Text(
                      optionLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
