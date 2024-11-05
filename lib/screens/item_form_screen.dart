// lib/screens/item_form_screen.dart
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;

  const ItemFormScreen({Key? key, this.item}) : super(key: key);

  @override
  _ItemFormScreenState createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item?.name ?? '';
      _descriptionController.text = widget.item?.description ?? '';
    }
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = Item(
        id: widget.item?.id ?? 0,
        name: _nameController.text,
        description: _descriptionController.text,
      );

      bool success;
      if (widget.item == null) {
        success = await apiService.createItem(newItem);
      } else {
        success = await apiService.updateItem(newItem);
      }

      if (!mounted) return;
      if (success) {
        Navigator.pop(context, 'refresh');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save item')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(widget.item == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
