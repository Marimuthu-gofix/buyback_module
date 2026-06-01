// import 'package:flutter/material.dart';
//
// class ProblemIssueCard extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//   final String iconPath;
//   final VoidCallback onTap;
//
//   const ProblemIssueCard({
//     super.key,
//     required this.title,
//     required this.isSelected,
//     required this.iconPath,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? const Color(0xFFFF64E6) : Colors.grey.shade700,
//             width: 2,
//           ),
//         ),
//         child: Stack(
//           children: [
//             /// MAIN CONTENT
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(iconPath, height: 100, fit: BoxFit.contain),
//                   const SizedBox(height: 12),
//                   Text(
//                     title,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: isSelected
//                           ? const Color(0xFFFF64E6)
//                           : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             /// ❌ BADGE (using Align)
//             if (isSelected)
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 4, right: 4),
//                   decoration: const BoxDecoration(
//                     color: const Color(0xFFFF64E6),
//                     shape: BoxShape.circle,
//                   ),
//                   width: 22,
//                   height: 22,
//                   child: const Icon(Icons.close, color: Colors.white, size: 14),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ProblemIssueCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final String iconPath;
  final VoidCallback onTap;

  const ProblemIssueCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            /// MAIN CONTENT
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconPath, height: 100, fit: BoxFit.contain),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            /// ❌ BADGE (using Align)
            if (isSelected)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 4, right: 4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  width: 22,
                  height: 22,
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
