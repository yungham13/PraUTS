// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000/items';

  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse(baseUrl));
    print('GET response: ${response.body}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((data) => Item.fromJson(data)).toList();
    } else {
      print('Failed to load items: ${response.statusCode}');
      throw Exception('Failed to load items');
    }
  }

  Future<bool> createItem(Item item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    print('POST response: ${response.body}');
    return response.statusCode == 201;
  }

  Future<bool> updateItem(Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    print('PUT response: ${response.body}');
    return response.statusCode == 200;
  }

  Future<bool> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    print('DELETE response: ${response.statusCode}');
    return response.statusCode == 200;
  }
}
