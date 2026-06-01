//
// import 'package:flutter/material.dart';
//
// class ProblemGridCard extends StatelessWidget {
//   final Map<String, String> options; // label -> icon
//   final Set<String> selectedItems;
//   final Function(String) onToggle;
//
//   const ProblemGridCard({
//     super.key,
//     required this.options,
//     required this.selectedItems,
//     required this.onToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: options.length,
//
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.95,
//       ),
//
//       itemBuilder: (_, index) {
//         final label = options.keys.elementAt(index);
//
//         final icon = options.values.elementAt(index);
//
//         final isSelected = selectedItems.contains(label);
//
//         return GestureDetector(
//           onTap: () => onToggle(label),
//
//           child: Container(
//             padding: const EdgeInsets.all(14),
//
//             decoration: BoxDecoration(
//               color: Colors.white,
//
//               borderRadius: BorderRadius.circular(16),
//
//               border: Border.all(
//                 color: isSelected ? Colors.red : Colors.grey.shade300,
//                 width: 2,
//               ),
//             ),
//
//             child: Stack(
//               children: [
//                 /// ✅ TOP RIGHT ICON
//                 Positioned(
//                   top: 0,
//                   right: 0,
//
//                   child: Container(
//                     height: 28,
//                     width: 28,
//
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.red : Colors.grey.shade200,
//
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//
//                     child: Icon(
//                       isSelected ? Icons.close : Icons.add,
//                       color: isSelected
//                           ? Colors.white
//                           : const Color(0xffFF4FD8),
//                       size: 18,
//                     ),
//                   ),
//                 ),
//
//                 /// ✅ CONTENT
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//
//                   children: [
//                     Image.asset(icon, height: 90, fit: BoxFit.contain),
//
//                     const SizedBox(height: 12),
//
//                     Text(
//                       label,
//                       textAlign: TextAlign.center,
//
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
//
// class ProblemGridCard extends StatelessWidget {
//   final Map<String, String> options; // label -> icon
//   final Set<String> selectedItems;
//   final Function(String) onToggle;
//
//   const ProblemGridCard({
//     super.key,
//     required this.options,
//     required this.selectedItems,
//     required this.onToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: options.length,
//
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.95,
//       ),
//
//       itemBuilder: (_, index) {
//         final label = options.keys.elementAt(index);
//
//         final icon = options.values.elementAt(index);
//
//         final isSelected = selectedItems.contains(label);
//
//         return GestureDetector(
//           onTap: () => onToggle(label),
//
//           child: Container(
//             padding: const EdgeInsets.all(14),
//
//             decoration: BoxDecoration(
//               color: isSelected ? const Color(0xFFA84B9E) : Colors.white,
//
//               borderRadius: BorderRadius.circular(16),
//
//               border: Border.all(
//                 color: isSelected ? Colors.red : Colors.grey.shade300,
//                 width: 2,
//               ),
//             ),
//
//             child: Stack(
//               clipBehavior: Clip.none,
//
//               children: [
//                 /// ✅ TOP RIGHT CORNER ICON
//                 Positioned(
//                   top: -8,
//                   right: -8,
//
//                   child: Container(
//                     height: 30,
//                     width: 30,
//
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.12),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//
//                     child: Center(
//                       child: Icon(
//                         isSelected ? Icons.close : Icons.add,
//
//                         color: isSelected
//                             ? const Color(0xFFE85B5B)
//                             : const Color(0xFFFF64E6),
//
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// ✅ CONTENT
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//
//                     children: [
//                       Image.asset(icon, height: 90, fit: BoxFit.contain),
//
//                       const SizedBox(height: 12),
//
//                       Text(
//                         label,
//                         textAlign: TextAlign.center,
//
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                           color: isSelected ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                color: isSelected ? Colors.red : Colors.grey.shade300,
                width: 2,
              ),
            ),

            child: Stack(
              clipBehavior: Clip.none,

              children: [
                /// ✅ TOP RIGHT CORNER ICON
                Positioned(
                  top: -8,
                  right: -8,

                  child: Container(
                    height: 22,
                    width: 22,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),

                    child: Center(
                      child: Icon(
                        isSelected ? Icons.close : Icons.add,

                        color: isSelected ? Colors.red : Colors.grey,

                        size: 18,
                      ),
                    ),
                  ),
                ),

                /// ✅ CONTENT
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Image.asset(icon, height: 90.h, fit: BoxFit.contain),

                      const SizedBox(height: 12),
                      Text(
                        label,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.2.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
