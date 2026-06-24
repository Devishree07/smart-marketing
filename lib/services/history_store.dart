import '../models/search_history.dart';

class HistoryStore {
  static final List<SearchHistory> _history = [];

  static List<SearchHistory> get all => _history;

  static void add(SearchHistory entry) {
    _history.insert(0, entry);
  }

  static void clear() {
    _history.clear();
  }

  static void removeAt(int index) {
    _history.removeAt(index);
  }

  static void insertAt(int index, SearchHistory entry) {
    _history.insert(index, entry);
  }
}