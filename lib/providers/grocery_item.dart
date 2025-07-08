import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

import 'package:http/http.dart' as http;
import 'package:shopping_list_app/providers/is_failed.dart';
import 'package:shopping_list_app/providers/is_loading.dart';

class GroceryItemNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemNotifier(this.ref) : super([]);

  final Ref ref;

  void addItem({
    required String enteredName,
    required int enteredQuantity,
    required Category selectedCategory,
    required BuildContext context,
  }) async {
    try {
      ref.read(isLoadingProvider.notifier).state = true;

      final Uri uri = Uri.https(
        "shopping-list-d9af2-default-rtdb.firebaseio.com",
        "shopping-list.json",
      );

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id": DateTime.now().toString(),
          "name": enteredName,
          "quantity": enteredQuantity,
          "category": selectedCategory.category,
        }),
      );

      state = [
        ...state,
        GroceryItem(
          id: json.decode(response.body)["name"],
          name: enteredName,
          quantity: enteredQuantity,
          category: selectedCategory,
        ),
      ];

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to save item")));
      }
    }

    ref.read(isLoadingProvider.notifier).state = false;
  }

  void removeItem(GroceryItem item, BuildContext context) async {
    final List<GroceryItem> pastState = [...state];
    state = state.where((i) => i != item).toList();

    try {
      final response = await http.delete(
        Uri.https(
          'shopping-list-d9af2-default-rtdb.firebaseio.com',
          'shopping-list/${item.id}.json',
        ),
      );

      response.statusCode >= 400 ? throw Exception() : null;
    } catch (error) {
      state = pastState;

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to delete")));
      }
    }
  }

  void loadItems() async {
    // ref.read(isLoadingProvider.notifier).state = true;

    final url = Uri.https(
      'shopping-list-d9af2-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    try {
      final response = await http.get(url);

      if (response.body == "null") {
        ref.read(isLoadingProvider.notifier).state = false;
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.category == item.value['category'],
            )
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      state = loadedItems;
    } catch (error) {
      Future(() {
        ref.read(isFailedProvider.notifier).state = true;
      });
    }

    Future(() {
      ref.read(isLoadingProvider.notifier).state = false;
    });
  }
}

final groceryItemProvider = StateNotifierProvider(
  (ref) => GroceryItemNotifier(ref),
);
