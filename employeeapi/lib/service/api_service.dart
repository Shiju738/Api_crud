// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'dart:convert';
import 'package:employeeapi/model/api_json.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService extends ChangeNotifier {
  final String apiUrl =
      'https://crudcrud.com/api/413c343452a04191914fb30eb6531f80/unicorns';

  Future<List<DataModel>> fetchData() async {
    try {
      print("This service is working....");
      final response = await http.get(Uri.parse(apiUrl));
      print(response);
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> apiData =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        return apiData.map((json) => DataModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in fetchData: $error');
      throw error;
    }
  }

  Future<DataModel> fetchDataById(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          return DataModel.fromJson(jsonData);
        } else {
          throw Exception('Empty response for ID: $id');
        }
      } else {
        throw Exception(
            'Failed to load data by ID. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in fetchDataById: $error');
      throw error;
    }
  }

  Future<DataModel> updateData(String id, DataModel updatedData) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData.toJson()),
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        notifyListeners(); // Notify listeners after successful update

        return DataModel.fromJson(responseData);
      } else {
        // Handle the case where the response body is empty
        print('Warning: Empty response body after updating data for ID: $id');
        notifyListeners(); // Notify listeners after successful update (assuming the update is considered successful)
        return DataModel(id: id); // Return a DataModel with the updated ID
      }
    } else {
      // Log the response body for debugging purposes
      print('Error updating data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update data for ID: $id');
    }
  }

  Future<void> deleteDataById(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      print('Employee with ID $id deleted successfully!');
      notifyListeners(); // Notify listeners after successful deletion
    } else {
      throw Exception('Failed to delete data by ID');
    }
  }

  Future<void> addData(DataModel employee) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(employee.toJson()),
      );

      if (response.statusCode == 201) {
        print('Employee added successfully!');
        notifyListeners(); // Notify listeners after successful addition
        await fetchData(); // Fetch updated data after successful addition
      } else {
        throw Exception(
            'Failed to add employee. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding employee: $error');
      rethrow;
    }
  }
}
