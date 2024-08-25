import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:glossy/glossy.dart';
import 'package:memotips/models/CollectionMode.dart';
import 'package:memotips/screens/Collections/serach.dart';
import 'package:memotips/screens/collections.dart';
import 'package:rive/rive.dart' as rive;
import 'package:watch_it/watch_it.dart';

final getIt = GetIt.instance;

class Collections extends WatchingStatefulWidget {
  const Collections({super.key});

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  final List<Map<String, dynamic>> collections = [
    {"title": "Relax", "icon": Icons.spa},
    {"title": "Focus", "icon": Icons.self_improvement},
    {"title": "Sleep", "icon": Icons.nights_stay},
    {"title": "Meditation", "icon": Icons.bubble_chart},
    {"title": "Music", "icon": Icons.music_note},
    {"title": "Workout", "icon": Icons.fitness_center},
  ];

  final List<Map<String, dynamic>> collectionsData = [
    {
      "title": "Relax",
      "icon": Icons.spa,
      "items": [
        {
          "type": "text",
          "content":
              "Breathe deepldskafjnalkdjfbglkdajbglk jbldkf gblkdfa jblkgjdbfalkgbdflkagblkfdjgblkfdgbjky"
        },
        {"type": "image", "content": "assets/images/img.png"},
        {"type": "link", "content": "https://google.com"},
      ]
    },
    {
      "title": "Focus",
      "icon": Icons.self_improvement,
      "items": [
        {"type": "text", "content": "Stay focused"},
        {"type": "image", "content": "assets/images/img.png"},
        {"type": "link", "content": "https://google.com"},
        {"type": "text", "content": "Think about what is important"},
      ]
    },
    // Add more collections as needed
  ];

  bool isGrid = false; // Toggle state

  @override
  Widget build(BuildContext context) {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card
    int? selectedItemIndex = watchPropertyValue((CollectionModel x) =>
        x.selectedCollectionIndex); // Track the selected item index

    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 40, 10, 0),
        child: selectedTitle != null &&
                collectionsData.any((collection) =>
                    collection['title'] == selectedTitle &&
                    collection['items'].isEmpty)
            ? Center(
                child: Text(
                  '404 Not Found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: SearchBarCollections()),
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
                  Expanded(
                    // Removed unnecessary Expanded widget here
                    child: selectedItemIndex != null
                        ? buildSwipeableItem(selectedItemIndex!)
                        : buildMasonryGrid(),
                  ),
                ],
              ),
      ),
    );
  }

  // Separate function for MasonryGridView
  Widget buildMasonryGrid() {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card

    // Check if selectedTitle is not null before using firstWhere
    if (selectedTitle != null) {
      final selectedCollection = collectionsData.firstWhere(
        (collection) => collection['title'] == selectedTitle,
        orElse: () =>
            {}, // Provide an empty object if no matching collection found
      );

      // Check if the collection has items
      if (selectedCollection['items'] != null &&
          selectedCollection['items'].isNotEmpty) {
        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: selectedCollection['items'].length +
              1, // Including "Create a Collection"
          itemBuilder: (context, index) {
            if (index == 0) {
              return CreateCollectionCard();
            }

            final collectionItems = selectedCollection['items'];
            final adjustedIndex = index - 1;

            return GestureDetector(
              onTap: () {
                setState(() {
                  getIt<CollectionModel>()
                      .setSelectedCollectionIndex(adjustedIndex);
                });
              },
              child: buildGridItem(collectionItems, adjustedIndex),
            );
          },
        );
      } else {
        // Show 404 if no items are found in the collection
        return Center(
            child: rive.RiveAnimation.asset(
          'assets/folder.riv',
        ));
      }
    } else {
      // Handle the case where selectedTitle is null (no collection selected)
      return MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount:
            collectionsData.length + 1, // Including "Create a Collection"
        itemBuilder: (context, index) {
          if (index == 0) {
            return CreateCollectionCard();
          }

          final collectionItems = collectionsData[index - 1]['items'];
          final adjustedIndex = index - 1;

          return GestureDetector(
            onTap: () {
              setState(() {
                getIt<CollectionModel>()
                    .setSelectedCollection(collectionsData[index - 1]['title']);
                getIt<CollectionModel>()
                    .setSelectedCollectionIndex(adjustedIndex);
              });
            },
            child: buildGridItem(collectionItems, adjustedIndex),
          );
        },
      );
    }
  }

  Widget buildGridItem(List<dynamic> collectionItems, int adjustedIndex) {
    final item = collectionItems[adjustedIndex];

    if (item['type'] == 'text') {
      return TextItemCard(
        item: item['content'],
        index: adjustedIndex,
      );
    } else if (item['type'] == 'image') {
      return ImageItemCard(
        imagePath: item['content'],
        index: adjustedIndex,
      );
    }

    return Container();
  }

  Widget buildSwipeableItem(int initialIndex) {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card
    int? selectedItemIndex = watchPropertyValue((CollectionModel x) =>
        x.selectedCollectionIndex); // Track the selected item index
    print("working");
    final selectedCollection = collectionsData.firstWhere(
      (collection) => collection['title'] == selectedTitle,
    )['items'];

    PageController _pageController = PageController(initialPage: initialIndex);

    return Stack(children: [
      PageView.builder(
        controller: _pageController,
        itemCount: selectedCollection.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final item = selectedCollection[index];
          return Center(
            child: buildGridItem(selectedCollection, index),
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
              borderRadius: BorderRadius.circular(100), color: Colors.black),
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
    ]);
  }

  Widget buildRowView() {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card
    int? selectedItemIndex = watchPropertyValue((CollectionModel x) =>
        x.selectedCollectionIndex); // Track the selected item index
    return SizedBox(
      height: 70, // Adjust this value as needed
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: collections.map((collection) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 8, 0),
              child: CollectionCard(
                title: collection['title'],
                icon: collection['icon'],
                isSelected: selectedTitle == collection['title'],
                onTap: () {
                  getIt<CollectionModel>()
                      .setSelectedCollection(collection['title']);

                  getIt<CollectionModel>().setSelectedCollectionIndex(null);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildGridView() {
    String? selectedTitle = watchPropertyValue(
        (CollectionModel x) => x.selectedCollection); // Track the selected card
    int? selectedItemIndex = watchPropertyValue((CollectionModel x) =>
        x.selectedCollectionIndex); // Track the selected item index
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
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return CollectionCard(
            title: collection['title'],
            icon: collection['icon'],
            isSelected: selectedTitle == collection['title'],
            onTap: () {
              getIt<CollectionModel>()
                  .setSelectedCollection(collection['title']);
              // selectedTitle = collection['title'];
              getIt<CollectionModel>().setSelectedCollectionIndex(null);
              // selectedItemIndex = null; // Reset selected item on card change
            },
          );
        },
      ),
    );
  }
}
