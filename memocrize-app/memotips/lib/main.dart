import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:memotips/models/CollectionMode.dart';
import 'package:memotips/navigation/bottomNavigation.dart';
import 'package:memotips/screens/Collections/collections.dart';
import 'package:memotips/screens/Memories/memories.dart';
import 'package:memotips/screens/home.dart';
import 'package:memotips/screens/qr_code.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<CollectionModel>(CollectionModel());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black, // status bar color
  ));
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "SpaceGrotesk",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(body: Collections()),
    );
  }
}
