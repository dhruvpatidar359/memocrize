import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';

class SearchBarCollections extends StatefulWidget {
  @override
  _SearchBarCollectionsState createState() => _SearchBarCollectionsState();
}

class _SearchBarCollectionsState extends State<SearchBarCollections> {
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
