import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:memotips/models/CollectionMode.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

class CreateCollectionCard extends StatelessWidget {
  final Function() onCollectionCreated;
  final double height;
  final double width;

  const CreateCollectionCard(
      {Key? key,
      required this.onCollectionCreated,
      required this.height,
      required this.width})
      : super(key: key);

  Future<void> _showCreateCollectionDialog(BuildContext context) async {
    String? collectionName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Create New Collection',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter collection name',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffFF8484),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffFF8484),
                ),
              ),
              hintStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              name = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Create',
                style: TextStyle(
                  color: Color(0xffFF8484),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(name);
              },
            ),
          ],
        );
      },
    );

    if (collectionName != null && collectionName.isNotEmpty) {
      await _createCollection(collectionName);
      onCollectionCreated();
    }
  }

  Future<void> _createCollection(String collectionName) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final collectionsDir = Directory('${appDocDir.path}/Collections');
      if (!await collectionsDir.exists()) {
        await collectionsDir.create(recursive: true);
      }

      final newCollectionDir =
          Directory('${collectionsDir.path}/$collectionName');
      if (!await newCollectionDir.exists()) {
        await newCollectionDir.create();
        print('Created new collection: $collectionName');
      } else {
        print('Collection already exists: $collectionName');
      }
    } catch (e) {
      print('Error creating collection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCreateCollectionDialog(context),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white60.withOpacity(0.15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create a",
              style: TextStyle(
                fontSize: 18,
                height: 0.8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Collection",
              style: TextStyle(
                color: Color(0xffFF8484),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback
      onRename; // Add this callback if you need to update parent state after renaming or deleting

  const CollectionCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.onRename, // Add this callback if needed
    super.key,
  });

  Future<void> renameCollection(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    String newName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Rename Collection',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter new collection name',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffFF8484)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffFF8484)),
              ),
              hintStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (newName.isNotEmpty) {
                  try {
                    final appDocDir = await getApplicationDocumentsDirectory();
                    final collectionsDir =
                        Directory('${appDocDir.path}/Collections');
                    final oldDir = Directory('${collectionsDir.path}/$title');
                    final newDir = Directory('${collectionsDir.path}/$newName');

                    if (await oldDir.exists()) {
                      await oldDir.rename(newDir.path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Collection renamed to $newName')),
                      );
                      onRename(); // Trigger callback after renaming
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error renaming collection: $e')),
                    );
                  }
                }
              },
              child: Text(
                'Rename',
                style: TextStyle(color: Color(0xffFF8484)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCollection(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Delete Collection',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete this collection?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final appDocDir = await getApplicationDocumentsDirectory();
                  final collectionsDir =
                      Directory('${appDocDir.path}/Collections');
                  final dirToDelete =
                      Directory('${collectionsDir.path}/$title');

                  if (await dirToDelete.exists()) {
                    await dirToDelete.delete(recursive: true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Collection deleted')),
                    );
                    onRename(); // Trigger callback after deleting
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting collection: $e')),
                  );
                }
              },
              child: Text(
                'Delete',
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
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              surfaceTintColor: Colors.black,
              title: Text(
                'Options',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.white),
                    title:
                        Text('Rename', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      renameCollection(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.white),
                    title:
                        Text('Delete', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      deleteCollection(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 100),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isSelected ? 70 : 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isSelected
                ? Color(0xffFF8484)
                : Colors.white60.withOpacity(0.15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black12,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  title.length < 20 ? title : title.substring(0, 20) + "...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageItemCard extends StatelessWidget {
  final String filePath;
  final int index;
  final void Function(String action) callBack; // Updated to accept action

  const ImageItemCard({
    required this.filePath,
    required this.index,
    required this.callBack,
    Key? key,
  }) : super(key: key);

  void deleteFile(BuildContext context) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File deleted successfully!')),
        );
        callBack('delete'); // Pass 'delete' action
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting file: $e')),
      );
    }
  }

  void renameFile(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    String newName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Rename File',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter new file name',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffFF8484)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffFF8484)),
              ),
              hintStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (newName.isNotEmpty) {
                  final file = File(filePath);
                  final newFilePath = '${file.parent.path}/$newName';
                  try {
                    await file.rename(newFilePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File renamed to $newName')),
                    );
                    callBack('rename'); // Pass 'rename' action
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error renaming file: $e')),
                    );
                  }
                }
              },
              child: Text(
                'Rename',
                style: TextStyle(color: Color(0xffFF8484)),
              ),
            ),
          ],
        );
      },
    );
  }

  void moveFile(BuildContext context, List<String> availableCollections) {
    String? selectedCollection;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Move File',
            style: TextStyle(color: Colors.white),
          ),
          content: DropdownButton<String>(
            dropdownColor: Colors.black,
            isExpanded: true,
            value: selectedCollection,
            hint: Text(
              'Select a collection',
              style: TextStyle(color: Colors.white),
            ),
            onChanged: (String? newValue) {
              selectedCollection = newValue;
            },
            items: availableCollections.map((String collection) {
              return DropdownMenuItem<String>(
                value: collection,
                child: Text(
                  collection,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (selectedCollection != null) {
                  try {
                    final file = File(filePath);
                    final newFilePath =
                        '${file.parent.parent.path}/$selectedCollection/${file.path.split('/').last}';
                    await file.rename(newFilePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('File moved to $selectedCollection')),
                    );
                    callBack('move'); // Pass 'move' action
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error moving file: $e')),
                    );
                  }
                }
              },
              child: Text(
                'Move',
                style: TextStyle(color: Color(0xffFF8484)),
              ),
            ),
          ],
        );
      },
    );
  }

  void fetchFolderNamesAndMove(BuildContext context) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final collectionsDir = Directory('${appDocDir.path}/Collections');
      if (await collectionsDir.exists()) {
        final folders = collectionsDir.listSync().whereType<Directory>();
        final folderNames =
            folders.map((folder) => folder.path.split('/').last).toList();

        // Pass the folder names to moveFile
        moveFile(context, folderNames);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collections directory does not exist.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching collections: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getIt<CollectionModel>().setSelectedCollectionIndex(index);
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                FutureBuilder<File>(
                  future: File(filePath).exists().then((exists) => exists
                      ? File(filePath)
                      : Future.error('File does not exist')),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Image.file(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Icon(Icons.error, color: Colors.white));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: PopupMenuButton<String>(
                    color: Colors.black,
                    onSelected: (value) {
                      if (value == 'Delete') {
                        deleteFile(context);
                      } else if (value == 'Rename') {
                        renameFile(context);
                      } else if (value == 'Move') {
                        fetchFolderNamesAndMove(context);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return ['Delete', 'Rename', 'Move'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList();
                    },
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    tooltip: 'More options',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextItemCard extends StatelessWidget {
  final String filePath;
  final int index;
  final void Function(String action)
      callBack; // Updated to accept an action string

  const TextItemCard({
    required this.filePath,
    required this.index,
    required this.callBack,
  });

  Future<String> readFile() async {
    try {
      final file = File(filePath);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return 'Error reading file: $e';
    }
  }

  void deleteFile(BuildContext context) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File deleted successfully!')),
        );
        callBack('delete'); // Pass 'delete' action
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting file: $e')),
      );
    }
  }

  void renameFile(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    String newName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Rename File',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter new file name',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffFF8484)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffFF8484)),
              ),
              hintStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (newName.isNotEmpty) {
                  final file = File(filePath);
                  final newFilePath = '${file.parent.path}/$newName';
                  try {
                    await file.rename(newFilePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File renamed to $newName')),
                    );
                    callBack('rename'); // Pass 'rename' action
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error renaming file: $e')),
                    );
                  }
                }
              },
              child: Text(
                'Rename',
                style: TextStyle(color: Color(0xffFF8484)),
              ),
            ),
          ],
        );
      },
    );
  }

  void moveFile(BuildContext context, List<String> availableCollections) {
    String? selectedCollection;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Text(
            'Move File',
            style: TextStyle(color: Colors.white),
          ),
          content: DropdownButton<String>(
            dropdownColor: Colors.black,
            isExpanded: true,
            value: selectedCollection,
            hint: Text(
              'Select a collection',
              style: TextStyle(color: Colors.white),
            ),
            onChanged: (String? newValue) {
              selectedCollection = newValue;
            },
            items: availableCollections.map((String collection) {
              return DropdownMenuItem<String>(
                value: collection,
                child: Text(
                  collection,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (selectedCollection != null) {
                  try {
                    final file = File(filePath);
                    final newFilePath =
                        '${file.parent.parent.path}/$selectedCollection/${file.path.split('/').last}';
                    await file.rename(newFilePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('File moved to $selectedCollection')),
                    );
                    callBack('move'); // Pass 'move' action
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error moving file: $e')),
                    );
                  }
                }
              },
              child: Text(
                'Move',
                style: TextStyle(color: Color(0xffFF8484)),
              ),
            ),
          ],
        );
      },
    );
  }

  void fetchFolderNamesAndMove(BuildContext context) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final collectionsDir = Directory('${appDocDir.path}/Collections');
      if (await collectionsDir.exists()) {
        final folders = collectionsDir.listSync().whereType<Directory>();
        final folderNames =
            folders.map((folder) => folder.path.split('/').last).toList();

        // Pass the folder names to moveFile
        moveFile(context, folderNames);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collections directory does not exist.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching collections: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getIt<CollectionModel>().setSelectedCollectionIndex(index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
              child: Center(
                child: FutureBuilder(
                  future: readFile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
            PopupMenuButton(
              color: Colors.black,
              onSelected: (value) async {
                final appDocDir = await getApplicationDocumentsDirectory();
                final collectionsDir =
                    Directory('${appDocDir.path}/Collections');
                final folders =
                    collectionsDir.listSync().whereType<Directory>();
                if (value == 'Delete') {
                  deleteFile(context);
                } else if (value == 'Rename') {
                  renameFile(context);
                } else if (value == 'Move') {
                  fetchFolderNamesAndMove(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return ['Delete', 'Rename', 'Move'].map((String choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList();
              },
              icon: Icon(Icons.more_vert, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
