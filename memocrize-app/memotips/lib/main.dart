import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:memotips/models/CollectionMode.dart';
import 'package:memotips/screens/Collections/collections.dart';
import 'package:memotips/screens/qr_code.dart';
import 'dart:io'; // Import the dart:io package
import 'package:path_provider/path_provider.dart'; // Import path_provider

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<CollectionModel>(CollectionModel());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black, // Status bar color
  ));

  // Ensure the Collections directory exists
  await createCollectionsDirectory();

  setup();
  runApp(const MyApp());
}

// Function to create the Collections directory if it doesn't exist
Future<void> createCollectionsDirectory() async {
  final appDocDir =
      await getApplicationDocumentsDirectory(); // Get app documents directory
  final collectionsDir = Directory(
      '${appDocDir.path}/Collections'); // Define the Collections directory path

  if (!(await collectionsDir.exists())) {
    await collectionsDir.create(recursive: true); // Create the directory
    print('Collections directory created at ${collectionsDir.path}');
  } else {
    print('Collections directory already exists at ${collectionsDir.path}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memocrize',
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
