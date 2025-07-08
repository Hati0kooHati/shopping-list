import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/providers/grocery_item.dart';
import 'package:shopping_list_app/providers/is_failed.dart';
import 'package:shopping_list_app/providers/is_loading.dart';
import 'package:shopping_list_app/screens/add_item.dart';

class GroceriesScreen extends ConsumerStatefulWidget {
  const GroceriesScreen({super.key});

  @override
  ConsumerState<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends ConsumerState<GroceriesScreen> {
  List<GroceryItem> groceryItems = [];
  void deleteItem(GroceryItem item) {
    ref.read(groceryItemProvider.notifier).removeItem(item, context);
  }

  @override
  void initState() {
    super.initState();

    Future(() {
      ref.read(isFailedProvider.notifier).state = false;
    });

    if (groceryItems.isEmpty) {
      Future(() {
        ref.read(isLoadingProvider.notifier).state = true;
      });

      ref.read(groceryItemProvider.notifier).loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center(child: Text("No Grocery Found"));
    groceryItems = ref.watch(groceryItemProvider);

    if (ref.watch(isLoadingProvider)) {
      body = const Center(child: CircularProgressIndicator());
    }

    if (groceryItems.isNotEmpty) {
      body = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final GroceryItem groceryItem = groceryItems[index];
          return Dismissible(
            key: ValueKey(groceryItems[index]),
            onDismissed: (direction) {
              deleteItem(groceryItems[index]);
            },
            child: ListTile(
              leading: Container(
                height: 24,
                width: 24,
                color: groceryItem.category.color,
              ),
              title: Text(groceryItem.name),
              trailing: Text(
                groceryItem.quantity.toString(),
                style: TextStyle(fontSize: 17),
              ),
            ),
          );
        },
      );
    }

    if (ref.watch(isFailedProvider)) {
      body = const Center(child: Text("Please try again"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItemScreen()),
              );
            },
            icon: Icon(Icons.add, size: 45),
          ),
        ],
      ),
      body: body,
    );
  }
}
