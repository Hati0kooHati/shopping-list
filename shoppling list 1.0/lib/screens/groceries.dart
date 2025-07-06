import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/add_item.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final GroceryItem groceryItem = groceryItems[index];
          return ListTile(
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
          );
        },
      ),
    );
  }
}
