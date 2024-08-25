import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:glossy/glossy.dart';

class Collections extends StatefulWidget {
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

  bool isGrid = false; // Toggle state
  String? selectedTitle; // Track the selected card

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 40, 10, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: SearchBar()),
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
            // if (selectedTitle != null) ...[
            //   Gap(20),
            //   Text(
            //     "Selected: $selectedTitle",
            //     style: TextStyle(color: Colors.white, fontSize: 18),
            //   ),
            // ],
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: collections.length * 2,
                itemBuilder: (context, index) {
                  // var collection = collections[index];
                  return Container(
                    height: 150,
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
                              color: Colors.white),
                        ),
                        Text(
                          "Collection",
                          style: TextStyle(
                              color: Color(0xffFF8484),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRowView() {
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
                  setState(() {
                    selectedTitle = collection['title'];
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildGridView() {
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
              setState(() {
                selectedTitle = collection['title'];
              });
            },
          );
        },
      ),
    );
  }
}

class CollectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CollectionCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  title,
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

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _handleSearch(String query) {
    print("Search query: $query");
  }

  @override
  Widget build(BuildContext context) {
    return GlossyContainer(
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
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              onSubmitted: (String query) {
                _handleSearch(query);
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
