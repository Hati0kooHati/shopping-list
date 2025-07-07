import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/providers/grocery_item.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String enteredName = "";
  int enteredQuantity = 1;
  Category selectedCategory = categories[Categories.vegetables]!;

  void resetItem() {
    _formKey.currentState!.reset();
  }

  void saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(groceryItemProvider.notifier)
          .addItem(
            GroceryItem(
              id: DateTime.now().toString(),
              name: enteredName,
              quantity: enteredQuantity,
              category: selectedCategory,
            ),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a new item")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,

                decoration: InputDecoration(label: Text("Title")),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter title";
                  }
                  return null;
                },

                onSaved: (newName) => enteredName = newName!,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text("quantity")),
                      initialValue: "1",

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter quantity";
                        }

                        if (int.tryParse(value) == null) {
                          return "Idiot, enter number";
                        }

                        if (int.tryParse(value)! < 0) {
                          return "Fucking pranker, write positive number";
                        }
                        return null;
                      },

                      onSaved: (newQuantity) =>
                          enteredQuantity = int.parse(newQuantity!),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedCategory,
                      items: [
                        for (MapEntry<Categories, Category> category
                            in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  height: 18,
                                  width: 18,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 8),
                                Text(category.key.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (newCategory) =>
                          selectedCategory = newCategory as Category,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: resetItem, child: Text("Cancel")),
                  ElevatedButton(onPressed: saveItem, child: Text("Save")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
