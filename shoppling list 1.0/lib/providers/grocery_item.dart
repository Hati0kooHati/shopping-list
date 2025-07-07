import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryItemNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemNotifier() : super([]);

  void addItem(GroceryItem newItem) {
    state = [...state, newItem];
  }

  void removeItem(GroceryItem item) {
    state = state.where((i) => i != item).toList();
  }
}

final groceryItemProvider = StateNotifierProvider(
  (ref) => GroceryItemNotifier(),
);
