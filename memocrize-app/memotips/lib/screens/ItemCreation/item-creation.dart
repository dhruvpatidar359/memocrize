import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glossy/glossy.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memotips/models/CollectionMode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watch_it/watch_it.dart'; // For accessing the app document directory

class TextItemCreation extends WatchingStatefulWidget {
  const TextItemCreation({super.key});

  @override
  State<TextItemCreation> createState() => _TextItemCreationState();
}

class _TextItemCreationState extends State<TextItemCreation> {
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _saveFile(String selectedCollection) async {
    // Retrieve the app document directory path
    final appDocDir = await getApplicationDocumentsDirectory();
    final collectionsDir = Directory('${appDocDir.path}/Collections');

    // Get the current selected collection name

    // Create the path for the selected collection folder
    final collectionDir =
        Directory('${collectionsDir.path}/$selectedCollection');

    // Create the directory if it doesn't exist
    if (!await collectionDir.exists()) {
      await collectionDir.create(recursive: true);
    }

    // Get the file name and text input from the controllers
    final fileName = _fileNameController.text.trim();
    final textContent = _textController.text.trim();

    // Check if the file name is empty or if the content is empty
    if (fileName.isEmpty || textContent.isEmpty) {
      _showErrorDialog('Please enter both a file name and some text content.');
      return;
    }

    // Define the full file path
    final filePath = '${collectionDir.path}/$fileName.txt';

    // Check if the file already exists
    if (await File(filePath).exists()) {
      _showErrorDialog('A file with the name "$fileName.txt" already exists.');
      return;
    }

    try {
      // Write the text content to the file
      final file = File(filePath);
      await file.writeAsString(textContent);

      // Return true to indicate successful save and pop the screen
      Navigator.pop(context, true);
    } catch (e) {
      // Handle any file writing errors
      _showErrorDialog('Failed to save the file. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Error',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xffFF8484)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCollection =
        watchPropertyValue((CollectionModel x) => x.selectedCollection);

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create a",
                      style: TextStyle(
                        fontSize: 48,
                        height: 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {_saveFile(selectedCollection!)},
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffFF8484),
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Text",
                  style: TextStyle(
                    color: Color(0xffFF8484),
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "File Name*",
                      style: TextStyle(color: Colors.white),
                    ),
                    Gap(10),
                    GlossyContainer(
                      height: 50,
                      color: Colors.white60.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border(),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(Icons.file_open, color: Colors.grey),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _fileNameController,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                hintText: 'Enter your file name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(10),
                    Text(
                      "Your Thing to Remember*",
                      style: TextStyle(color: Colors.white),
                    ),
                    Gap(10),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: GlossyContainer(
                        height: MediaQuery.sizeOf(context).height / 1.8,
                        color: Colors.white60.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border(),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              hintText: 'Text....',
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageItemCreation extends WatchingStatefulWidget {
  const ImageItemCreation({super.key});

  @override
  State<ImageItemCreation> createState() => _ImageItemCreationState();
}

class _ImageItemCreationState extends State<ImageItemCreation> {
  final TextEditingController _fileNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<void> _saveImage(String selectedCollection) async {
    // Retrieve the app document directory path
    final appDocDir = await getApplicationDocumentsDirectory();
    final collectionsDir = Directory('${appDocDir.path}/Collections');

    // Get the current selected collection name using watchPropertyValue

    // Create the path for the selected collection folder
    final collectionDir =
        Directory('${collectionsDir.path}/$selectedCollection');

    // Create the directory if it doesn't exist
    if (!await collectionDir.exists()) {
      await collectionDir.create(recursive: true);
    }

    // Get the file name and ensure an image is selected
    final fileName = _fileNameController.text.trim();
    if (_imageFile == null || fileName.isEmpty) {
      _showErrorDialog('Please enter a file name and select an image.');
      return;
    }

    // Define the full file path
    final filePath = '${collectionDir.path}/$fileName.jpg';

    // Check if the file already exists
    if (await File(filePath).exists()) {
      _showErrorDialog('A file with the name "$fileName.jpg" already exists.');
      return;
    }

    try {
      // Copy the selected image to the desired path
      await _imageFile!.saveTo(filePath);

      // Return true to indicate successful save and pop the screen
      Navigator.pop(context, true);
    } catch (e) {
      // Handle any file writing errors
      _showErrorDialog('Failed to save the image. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Error',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xffFF8484)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCollection =
        watchPropertyValue((CollectionModel x) => x.selectedCollection);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create a",
                      style: TextStyle(
                          fontSize: 48,
                          height: 0.8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        _saveImage(selectedCollection!);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffFF8484),
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Image",
                  style: TextStyle(
                      color: Color(0xffFF8484),
                      fontSize: 64,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "File Name*",
                      style: TextStyle(color: Colors.white),
                    ),
                    Gap(10),
                    GlossyContainer(
                      height: 50,
                      color: Colors.white60.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border(),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(Icons.file_open, color: Colors.grey),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _fileNameController,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                hintText: 'Enter your file name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(20),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _pickFromGallery,
                          child: GlossyContainer(
                            height: 50,
                            color: Colors.white60.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border(),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                'Pick from Gallery',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: _openCamera,
                          child: GlossyContainer(
                            height: 50,
                            color: Colors.white60.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border(),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                'Open Camera',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    if (_imageFile != null)
                      GlossyContainer(
                        height: 300,
                        color: Colors.white60.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border(),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                            File(_imageFile!.path),
                          ))),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
