import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void resetItem() {
    _formKey.currentState!.reset();
  }

  void saveItem() {
    _formKey.currentState!.validate();
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
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
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
                      onChanged: (value) {},
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
