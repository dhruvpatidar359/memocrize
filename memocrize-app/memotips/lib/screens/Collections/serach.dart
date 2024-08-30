import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class SearchBarCollections extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarCollections({Key? key, required this.onSearch})
      : super(key: key);

  @override
  _SearchBarCollectionsState createState() => _SearchBarCollectionsState();
}

class _SearchBarCollectionsState extends State<SearchBarCollections> {
  final TextEditingController _controller = TextEditingController();

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
              onChanged: (String query) {
                widget.onSearch(query);
              },
            ),
          ),
        ],
      ),
    );
  }
}
