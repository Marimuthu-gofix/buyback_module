// import 'dart:ui';
// import 'package:buyback/Pages/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
//
// import '../../../Providers/evaluation_provider.dart';
//
// class BookingSuccessPopup extends StatelessWidget {
//   final String customerName;
//   final String email;
//   final String appointmentDate;
//   final String appointmentTime;
//
//   const BookingSuccessPopup({
//     super.key,
//     required this.customerName,
//     required this.email,
//     required this.appointmentDate,
//     required this.appointmentTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         type: MaterialType.transparency,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.88,
//               padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.white.withOpacity(0.28),
//                     Colors.pink.withOpacity(0.45),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 border: Border.all(
//                   width: 1.2,
//                   color: Colors.white.withOpacity(0.28),
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const CircleAvatar(
//                         radius: 15,
//                         backgroundColor: Colors.black87,
//                         child: Icon(Icons.close, color: Colors.white, size: 18),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   Center(
//                     child: Text(
//                       "Booking Successful !",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white.withOpacity(0.95),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   _detail("Customer Name", customerName),
//                   _detail("Email", email),
//                   _detail("Appointment Date", appointmentDate),
//                   _detail("Appointment Time", appointmentTime),
//
//                   const SizedBox(height: 18),
//
//                   Center(
//                     child: Image.asset("Images/booking/pickup.png", width: 240),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.85),
//                       borderRadius: BorderRadius.circular(18),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: const Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Store Visit Schedule",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "Please visit our store at the Scheduled time",
//                           style: TextStyle(fontSize: 13, color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 22),
//
//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         /// CLEAR ALL DATA
//                         context.read<EvaluationProvider>().clearAll();
//
//                         /// GO HOME
//                         Navigator.pushAndRemoveUntil(
//                           context,
//
//                           MaterialPageRoute(builder: (_) => home()),
//
//                           (route) => false,
//                         );
//                       },
//                       icon: const Icon(Icons.home),
//                       label: const Text("Home"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFEA21A2),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 12,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _detail(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 145,
//             child: Text(
//               "$title :",
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(value, style: const TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Providers/evaluation_provider.dart';
import '../../home.dart';


class BookingSuccessPopup extends StatelessWidget {
  final String customerName;

  final String email;

  final String appointmentDate;

  final String appointmentTime;

  const BookingSuccessPopup({
    super.key,
    required this.customerName,
    required this.email,
    required this.appointmentDate,
    required this.appointmentTime,
    required String mobileNo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,

              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),

                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.28),

                    Colors.pink.withOpacity(0.45),
                  ],

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,
                ),

                border: Border.all(
                  width: 1.2,

                  color: Colors.white.withOpacity(0.28),
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// CLOSE
                  Align(
                    alignment: Alignment.topRight,

                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: const CircleAvatar(
                        radius: 15,

                        backgroundColor: Colors.black87,

                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// TITLE
                  Center(
                    child: Text(
                      "Booking Successful !",

                      style: TextStyle(
                        fontSize: 22,

                        fontWeight: FontWeight.w900,

                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DETAILS
                  _detail("Customer Name", customerName),

                  _detail("Email", email),

                  _detail("Appointment Date", appointmentDate),

                  _detail("Appointment Time", appointmentTime),

                  const SizedBox(height: 18),

                  /// IMAGE
                  Center(
                    child: Image.asset("Images/booking/pickup.png", width: 240),
                  ),

                  const SizedBox(height: 12),

                  /// STORE VISIT BOX
                  Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(18),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,

                          blurRadius: 10,

                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Store Visit Schedule",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Please visit our store at the Scheduled time",

                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// HOME BUTTON
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        /// CLEAR PROVIDER
                        context.read<EvaluationProvider>().clearAll();

                        /// GO HOME
                        Navigator.pushAndRemoveUntil(
                          context,

                          MaterialPageRoute(builder: (_) => home()),

                          (route) => false,
                        );
                      },

                      icon: const Icon(Icons.home, color: Colors.white),

                      label: const Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF4FD8),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// DETAIL ROW
  Widget _detail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        children: [
          SizedBox(
            width: 145,

            child: Text(
              "$title :",

              style: const TextStyle(
                fontWeight: FontWeight.w600,

                color: Colors.white,
              ),
            ),
          ),

          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
