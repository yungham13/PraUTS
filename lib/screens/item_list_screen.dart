// lib/screens/item_list_screen.dart
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';
import 'item_form_screen.dart';

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Item>> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = apiService.getItems();
  }

  Future<void> _refreshItems() async {
    setState(() {
      itemsFuture = apiService.getItems();
    });
  }

  void _navigateToForm({Item? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemFormScreen(item: item),
      ),
    );
    if (result == 'refresh') {
      _refreshItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: FutureBuilder<List<Item>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await apiService.deleteItem(item.id);
                      _refreshItems();
                    },
                  ),
                  onTap: () => _navigateToForm(item: item),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
