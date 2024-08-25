import 'package:flutter/foundation.dart';

class CollectionModel extends ChangeNotifier {
  int _selectedCollectionIndex = 0;
  String? _selectedCollection;

  int get selectedCollectionIndex => _selectedCollectionIndex;
  String? get selectedCollection => _selectedCollection;

  void setSelectedCollectionIndex(int index) {
    _selectedCollectionIndex = index;
    notifyListeners();
  }

  void setSelectedCollection(String collection) {
    _selectedCollection = collection;
    notifyListeners();
  }
}
