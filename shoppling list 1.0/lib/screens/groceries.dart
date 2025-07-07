import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/providers/grocery_item.dart';
import 'package:shopping_list_app/screens/add_item.dart';

class GroceriesScreen extends ConsumerStatefulWidget {
  const GroceriesScreen({super.key});

  @override
  ConsumerState<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends ConsumerState<GroceriesScreen> {
  void deleteItem(GroceryItem item) {
    ref.read(groceryItemProvider.notifier).removeItem(item);
  }

  @override
  Widget build(BuildContext context) {
    final List<GroceryItem> groceryItems = ref.watch(groceryItemProvider);
    Widget body = const Center(child: Text("No Grocery Found"));

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddItemScreen()),
            ),
            icon: Icon(Icons.add, size: 45),
          ),
        ],
      ),
      body: body,
    );
  }
}
