// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:glossy/glossy.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:mesh/mesh.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(children: [
//             MyWidget(),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Container(
//                   height: MediaQuery.sizeOf(context).height,
//                   width: MediaQuery.sizeOf(context).width,
//                   color: Colors.white60.withOpacity(0.05),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Create a",
//                               style: TextStyle(
//                                   fontSize: 48,
//                                   height: 0.8,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             Text(
//                               "Memory",
//                               style: TextStyle(
//                                   color: Color(0xffFF8484),
//                                   fontSize: 64,
//                                   fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                       Gap(20),
//                       Container(
//                         height: 220,
//                         child: Row(
//                           children: [
//                             // Wrap each container in Expanded to distribute space equally
//                             Expanded(
//                               child: GlossyContainer(
//                                 // border: ,
//                                 border:
//                                     Border.all(color: Colors.white, width: 2),
//                                 borderRadius: BorderRadius.circular(20),
//                                 height: 210,
//                                 width: MediaQuery.sizeOf(context).width / 2,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Icon(
//                                         Icons.text_fields_sharp,
//                                         size: 48,
//                                         color: Colors.white,
//                                       ),
//                                       Text(
//                                         "Write it Out",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: 36,
//                                           height: 1,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Gap(10), // Fixed gap between containers
//                             Expanded(
//                               child: GlossyContainer(
//                                 // border: ,
//                                 border:
//                                     Border.all(color: Colors.white, width: 2),
//                                 borderRadius: BorderRadius.circular(20),
//                                 height: 210,
//                                 width: MediaQuery.sizeOf(context).width / 2,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Icon(
//                                         Icons.camera,
//                                         size: 48,
//                                         color: Colors.white,
//                                       ),
//                                       Text(
//                                         "Take it Out",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: 36,
//                                           height: 1,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Gap(10),
//                       GlossyContainer(
//                         // border: ,
//                         border: Border.all(color: Colors.white, width: 2),
//                         borderRadius: BorderRadius.circular(20),
//                         height: 160,
//                         width: MediaQuery.sizeOf(context).width,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(
//                             child: Text(
//                               "Video",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 36,
//                                 height: 1,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ])),
//     );
//   }
// }
//
// extension on OVertex {
//   OVertex to(OVertex b, double t) => OVertex.lerp(this, b, t);
// }
//
// extension on Color? {
//   Color? to(Color? b, double t) => Color.lerp(this, b, t);
// }
//
// typedef C = Colors;
//
// // Now the actual example
//
// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});
//
//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }
//
// class _MyWidgetState extends State<MyWidget>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController controller = AnimationController(vsync: this)
//     ..duration = const Duration(seconds: 5)
//     ..forward()
//     ..addListener(() {
//       if (controller.value == 1.0) {
//         controller.animateTo(0, curve: Curves.easeInOutQuint);
//       }
//       if (controller.value == 0.0) {
//         controller.animateTo(1, curve: Curves.easeInOutCubic);
//       }
//     });
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: AnimatedBuilder(
//         animation: controller,
//         builder: (context, _) {
//           final dt = controller.value;
//           return OMeshGradient(
//             tessellation: 12,
//             size: Size.infinite,
//             mesh: OMeshRect(
//               width: 3,
//               height: 4,
//               // We have some different color spaces available
//               colorSpace: OMeshColorSpace.lab,
//               fallbackColor: C.transparent,
//               vertices: [
//                 (0.0, 0.3).v.to((0.0, 0.0).v, dt),
//                 (0.5, 0.15).v.to((0.5, 0.1).v, dt * dt),
//                 (1.0, -0.1).v.to((1.0, 0.3).v, dt * dt), //
//
//                 (-0.05, 0.68).v.to((0.0, 0.45).v, dt),
//                 (0.63, 0.3).v.to((0.48, 0.54).v, dt),
//                 (1.0, 0.1).v.to((1.0, 0.6).v, dt), //
//
//                 (-0.2, 0.92).v.to((0.0, 0.58).v, dt),
//                 (0.32, 0.72).v.to((0.58, 0.69).v, dt * dt),
//                 (1.0, 0.3).v.to((1.0, 0.8).v, dt), //
//
//                 (0.0, 1.2).v.to((0.0, 0.86).v, dt),
//                 (0.5, 0.88).v.to((0.5, 0.95).v, dt),
//                 (1.0, 0.82).v.to((1.0, 1.0).v, dt), //
//               ],
//               colors: [
//                 null, null, null, //
//
//                 C.orange[500]
//                     ?.withOpacity(0.8)
//                     .to(const Color.fromARGB(255, 10, 33, 122), dt),
//                 C.orange[200]
//                     ?.withOpacity(0.8)
//                     .to(const Color.fromARGB(252, 103, 48, 205), dt),
//                 C.orange[400]
//                     ?.withOpacity(0.90)
//                     .to(const Color.fromARGB(252, 103, 53, 128), dt), //
//
//                 C.orange[900].to(const Color.fromARGB(225, 9, 20, 109), dt),
//                 C.orange[800]
//                     ?.withOpacity(0.98)
//                     .to(const Color.fromARGB(255, 103, 48, 205), dt),
//                 C.orange[900].to(const Color.fromARGB(255, 83, 0, 124), dt), //
//
//                 null, null, null, //
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
