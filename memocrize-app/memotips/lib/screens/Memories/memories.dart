// import 'package:flutter/material.dart';
// import 'package:memotips/screens/Collections/cards.dart';
//
// class Memories extends StatefulWidget {
//   const Memories({super.key});
//
//   @override
//   State<Memories> createState() => _MemoriesState();
// }
//
// class _MemoriesState extends State<Memories> {
//   bool isAscending = true; // Initially sort ascending
//
//   final List<Map<String, dynamic>> memoriesData = [
//     {
//       "date": DateTime(2023, 11, 20),
//       "items": [
//         {
//           "type": "text",
//           "content": "This is a text memory from November 20th.",
//           "tags": ["travel", "adventure"]
//         },
//         {
//           "type": "image",
//           "content": "assets/images/img.png", // Replace with actual image path
//           "tags": ["nature", "mountains"]
//         },
//       ]
//     },
//     {
//       "date": DateTime(2023, 11, 18),
//       "items": [
//         {
//           "type": "text",
//           "content": "Another text memory from November 18th.",
//           "tags": ["work", "project"]
//         },
//         {
//           "type": "image",
//           "content": "assets/images/img.png", // Replace with actual image path
//           "tags": ["family", "celebration"]
//         },
//       ]
//     },
//     // Add more memories as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     memoriesData.sort((a, b) {
//       // Sort by date in ascending or descending order
//       if (isAscending) {
//         return a['date'].compareTo(b['date']);
//       } else {
//         return b['date'].compareTo(a['date']);
//       }
//     });
//
//     return Container(
//       color: Colors.black,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(10.0, 40, 10, 0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 // Expanded(child: SearchBarCollections()),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       isAscending = !isAscending;
//                     });
//                   },
//                   icon: Icon(
//                     isAscending ? Icons.arrow_upward : Icons.arrow_downward,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: memoriesData.length,
//                 itemBuilder: (context, index) {
//                   final memory = memoriesData[index];
//                   final date = memory['date'];
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "${date.day}/${date.month}/${date.year}",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       ...memory['items'].map((item) {
//                         if (item['type'] == 'text') {
//                           return Padding(
//                             padding: const EdgeInsets.fromLTRB(4.0, 10, 4, 10),
//                             child: TextItemCard(
//                               callBack: () {
//                                 setState(() {});
//                               },
//                               index: index,
//                               filePath: item['content'],
//                             ),
//                           );
//                         } else if (item['type'] == 'image') {
//                           return Padding(
//                             padding: const EdgeInsets.fromLTRB(4.0, 10, 4, 10),
//                             child: ImageItemCard(
//                                 imagePath: item['content'], index: index),
//                           );
//                         }
//                         return Container();
//                       }).toList(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
