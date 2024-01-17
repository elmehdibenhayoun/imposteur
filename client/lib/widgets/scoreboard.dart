// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tic_tac_toe/provider/room_data_provider.dart';
// import 'package:tic_tac_toe/util/dimension.dart';

// class ScoreBoardWidget extends StatelessWidget {
//   const ScoreBoardWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
    
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
        
//         Padding(
//           padding: padding30,
//           child: Column(
//             children: [
//               Text(
//                 roomDataProvider.p1.nickName,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
              
//             ],
//           ),
//         ),
//         Padding(
//           padding: padding30,
//           child: Column(
//             children: [
//               Text(
//                 roomDataProvider.p2.nickName,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
              
//             ],
//           ),
//         ),
//         Padding(
//           padding: padding30,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 roomDataProvider.p3.nickName,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
              
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
