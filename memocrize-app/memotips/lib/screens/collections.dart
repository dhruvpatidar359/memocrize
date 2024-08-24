import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glossy/glossy.dart';

class Collections extends StatefulWidget {
  const Collections({super.key});

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
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
                GlossyContainer(
                  height: 50, // Adjust height as needed
                  color: Colors.white60.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border(),
                  width: 50,
                  child: Center(
                      child: Icon(
                    Icons.table_rows,
                    color: Colors.grey,
                  )),
                )
              ],
            ),
            Gap(15),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                child: SingleChildScrollView(
                  child: Row(
                      children: List.generate(
                    10,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 8, 0),
                        child: CollectionCard(),
                      );
                    },
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlossyContainer(
      height: 50,
      width: 100,
      color: Colors.white60.withOpacity(0.05),
      borderRadius: BorderRadius.circular(15),
      border: Border(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          Text(
            "Relax",
            style: TextStyle(color: Colors.white),
          )
        ],
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
    // Handle the search action here
    print("Search query: $query");
  }

  @override
  Widget build(BuildContext context) {
    return GlossyContainer(
      height: 50, // Adjust height as needed
      color: Colors.white60.withOpacity(0.05),
      borderRadius: BorderRadius.circular(15),
      border: Border(),
      width: MediaQuery.of(context).size.width, // Full width of the screen

      child: Row(
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
                _controller
                    .clear(); // Optionally clear the text field after search
              },
            ),
          ),
        ],
      ),
    );
  }
}
