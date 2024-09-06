import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:glossy/glossy.dart';
import 'package:memotips/models/CollectionMode.dart';
import 'package:memotips/screens/Collections/serach.dart';
import 'package:memotips/screens/Collections/cards.dart';

import 'package:watch_it/watch_it.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:image_picker/image_picker.dart'; // Import image_picker

final getIt = GetIt.instance;

class Collections extends WatchingStatefulWidget {
  const Collections({super.key});

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  @override
  void initState() {
    super.initState();
    fetchCollections(); // Fetch the collections when the widget initializes
  }

  final List<Map<String, dynamic>> collections = [];
  String searchQuery = '';
  List<Map<String, dynamic>> filteredCollections = [];
  final ScrollController _scrollController = ScrollController();
  void _scrollToSelected(int index) {
    // Calculate the offset to center the selected item
    final double offset =
        (index * 100) - (MediaQuery.of(context).size.width / 2) + 50;
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void searchCollections(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredCollections = List.from(collections);
      } else {
        filteredCollections = collections.where((collection) {
          return collection['title']
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();

        // Sort the filtered collections based on how well they match the query
        filteredCollections.sort((a, b) {
          int aIndex = a['title'].toLowerCase().indexOf(query.toLowerCase());
          int bIndex = b['title'].toLowerCase().indexOf(query.toLowerCase());
          return aIndex.compareTo(bIndex);
        });
      }
    });
  }

  void fetchCollections() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final collectionsDir = Directory('${appDocDir.path}/Collections');

    if (await collectionsDir.exists()) {
      final folders = collectionsDir.listSync().whereType<Directory>();

      setState(() {
        collections.clear();
        for (var folder in folders) {
          String title = folder.path.split('/').last;
          List<Map<String, dynamic>> items = [];

          // List all files in the folder
          final files = folder.listSync().whereType<File>();
          for (var file in files) {
            String fileName = file.path.split('/').last;
            String extension = fileName.split('.').last.toLowerCase();

            // Determine the type based on file extension
            String type = 'text';
            if (['jpg', 'jpeg', 'png'].contains(extension)) {
              type = 'image';
            }

            items.add({
              "type": type,
              "content": file.path,
            });
          }

          collections.add({
            "title": title,
            "icon": Icons.folder, // Using folder icon
            "items": items,
          });
        }
      });
      setState(() {
        filteredCollections = List.from(collections);
      });
      print(collections);
    } else {
      print('Collections directory does not exist.');
    }
  }

  bool isGrid = false; // Toggle state

  @override
  Widget build(BuildContext context) {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card
    int? selectedItemIndex = watchPropertyValue((CollectionModel x) =>
        x.selectedCollectionIndex); // Track the selected item index

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 40, 10, 0),
          child: selectedItemIndex == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: SearchBarCollections(
                                onSearch: searchCollections)),
                        Gap(10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isGrid = !isGrid;
                            });
                          },
                          child: GlossyContainer(
                            height: 50,
                            width: 50,
                            color: Colors.white60.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border(),
                            child: Center(
                              child: Icon(
                                isGrid ? Icons.grid_view : Icons.table_rows,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(15),
                    isGrid ? buildGridView() : buildRowView(),
                    Gap(15),
                    if (!isGrid)
                      Expanded(
                        child: buildMasonryGrid(),
                      ),
                  ],
                )
              : buildSwipeableItem(selectedItemIndex!),
        ),
      ),
    );
  }

  Widget buildMasonryGrid() {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card

    if (selectedTitle != null) {
      final selectedCollection = collections.firstWhere(
        (collection) => collection['title'] == selectedTitle,
        orElse: () =>
            {}, // Provide an empty object if no matching collection found
      );

      if (selectedCollection['items'] != null &&
          selectedCollection['items'].isNotEmpty) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Get the current index of the selected collection
            int currentIndex = collections.indexWhere(
                (collection) => collection['title'] == selectedTitle);

            if (details.primaryVelocity! < 0) {
              // Swipe Right
              int nextIndex = (currentIndex + 1) % collections.length;
              getIt<CollectionModel>()
                  .setSelectedCollection(collections[nextIndex]['title']);
            } else if (details.primaryVelocity! > 0) {
              // Swipe Left
              int prevIndex =
                  (currentIndex - 1 + collections.length) % collections.length;
              getIt<CollectionModel>()
                  .setSelectedCollection(collections[prevIndex]['title']);
            }
          },
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: selectedCollection['items'].length +
                3, // Including "Create a Collection", "CreateTextItem", and "CreateImageItem"
            itemBuilder: (context, index) {
              if (index == 0) {
                return CreateCollectionCard(
                  height: 150,
                  width: MediaQuery.sizeOf(context).width,
                  onCollectionCreated: () {
                    // Refresh the collections list
                    setState(() {
                      fetchCollections();
                    });
                  },
                );
              } else if (index == 1) {
                return CreateTextItem(
                  onCollectionCreated: () {
                    fetchCollections();
                  },
                  height: MediaQuery.sizeOf(context).height / 4,
                  width: MediaQuery.sizeOf(context).width / 2,
                );
              } else if (index == 2) {
                return CreateImageItem(
                  onCollectionCreated: () {
                    fetchCollections();
                  },
                  height: MediaQuery.sizeOf(context).height / 4,
                  width: MediaQuery.sizeOf(context).width / 2,
                );
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    getIt<CollectionModel>()
                        .setSelectedCollection(selectedCollection['title']);
                    getIt<CollectionModel>()
                        .setSelectedCollectionIndex(index - 3);
                  });
                },
                child: buildGridItem(
                    selectedCollection['items'], index - 3), // Adjust index
              );
            },
          ),
        );
      } else {
        return Center(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              // Get the current index of the selected collection
              int currentIndex = collections.indexWhere(
                  (collection) => collection['title'] == selectedTitle);

              if (details.primaryVelocity! < 0) {
                // Swipe Right
                int nextIndex = (currentIndex + 1) % collections.length;
                getIt<CollectionModel>()
                    .setSelectedCollection(collections[nextIndex]['title']);
              } else if (details.primaryVelocity! > 0) {
                // Swipe Left
                int prevIndex = (currentIndex - 1 + collections.length) %
                    collections.length;
                getIt<CollectionModel>()
                    .setSelectedCollection(collections[prevIndex]['title']);
              }
            },
            child: Column(
              children: [
                Expanded(
                  flex: 1, // This takes half of the available height
                  child: CreateCollectionCard(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    onCollectionCreated: () {
                      // Refresh the collections list
                      setState(() {
                        fetchCollections();
                      });
                    },
                  ),
                ),
                Gap(10),
                Expanded(
                  flex:
                      1, // This takes the remaining half of the available height
                  child: Row(
                    children: [
                      Expanded(
                        child: CreateTextItem(
                          onCollectionCreated: () {
                            fetchCollections();
                          },
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width / 2,
                        ),
                      ),
                      Gap(10),
                      Expanded(
                        child: CreateImageItem(
                          onCollectionCreated: () {
                            fetchCollections();
                          },
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width / 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Widget buildGridItem(List<dynamic> collectionItems, int adjustedIndex) {
    final item = collectionItems[adjustedIndex];

    if (item['type'] == 'text') {
      return TextItemCard(
        callBack: (action) {
          fetchCollections();
        },
        filePath: item['content'],
        index: adjustedIndex,
      );
    } else if (item['type'] == 'image') {
      return ImageItemCard(
        callBack: (action) {
          setState(() {
            fetchCollections(); // Refetch collections on rename or move
          });
        },
        filePath: item['content'],
        index: adjustedIndex,
      );
    }

    return Container();
  }

  Widget swipeBuildGridItem(List<dynamic> collectionItems, int adjustedIndex) {
    final item = collectionItems[adjustedIndex];

    if (item['type'] == 'text') {
      return TextItemCard(
        callBack: (action) {
          fetchCollections();
        },
        filePath: item['content'],
        index: adjustedIndex,
      );
    } else if (item['type'] == 'image') {
      return SwipeImageItemCard(
        callBack: (action) {
          setState(() {
            fetchCollections(); // Refetch collections on rename or move
          });
        },
        filePath: item['content'],
        index: adjustedIndex,
      );
    }

    return Container();
  }

  Widget buildSwipeableItem(int initialIndex) {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card

    if (selectedTitle != null) {
      final selectedCollection = collections.firstWhere(
        (collection) => collection['title'] == selectedTitle,
      );

      PageController _pageController =
          PageController(initialPage: initialIndex);

      return Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: selectedCollection['items'].length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final item = selectedCollection['items'][index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                child: Center(
                  child: swipeBuildGridItem(selectedCollection['items'], index),
                ),
              );
            },
            onPageChanged: (index) {
              getIt<CollectionModel>().setSelectedCollectionIndex(index);
            },
          ),
          Align(
            alignment: Alignment(-0.95, -0.95),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                child: IconButton(
                    onPressed: () {
                      getIt<CollectionModel>().setSelectedCollectionIndex(null);
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
              ),
            ),
          ),
        ],
      );
    }

    return Container(); // Return an empty container if selectedTitle is null
  }

  Widget buildRowView() {
    String? selectedTitle =
        watchPropertyValue((CollectionModel x) => x.selectedCollection);

    return SizedBox(
      height: 70,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: filteredCollections.asMap().entries.map((entry) {
            int index = entry.key;
            var collection = entry.value;
            bool isSelected = selectedTitle == collection['title'];

            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 8, 0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTitle = collection['title'];
                    getIt<CollectionModel>()
                        .setSelectedCollection(collection['title']);
                    getIt<CollectionModel>().setSelectedCollectionIndex(null);
                  });
                  _scrollToSelected(index); // Center the selected item
                },
                child: CollectionCard(
                  title: collection['title'],
                  icon: collection['icon'],
                  isSelected: isSelected,
                  onTap: () {
                    getIt<CollectionModel>()
                        .setSelectedCollection(collection['title']);
                    getIt<CollectionModel>().setSelectedCollectionIndex(null);
                    _scrollToSelected(index); // Center the selected item
                  },
                  onRename: () {
                    setState(() {
                      fetchCollections(); // Refetch collections to reflect changes
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildGridView() {
    String? selectedTitle =
        watchPropertyValue((CollectionModel x) => x.selectedCollection);
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredCollections.length,
        itemBuilder: (context, index) {
          final collection = filteredCollections[index];
          return CollectionCard(
            title: collection['title'],
            icon: collection['icon'],
            isSelected: selectedTitle == collection['title'],
            onTap: () {
              getIt<CollectionModel>()
                  .setSelectedCollection(collection['title']);
              getIt<CollectionModel>().setSelectedCollectionIndex(null);
            },
            onRename: () {
              setState(() {
                fetchCollections(); // Refetch collections to reflect changes
              });
            },
          );
        },
      ),
    );
  }
}
