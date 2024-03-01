// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:employeeapi/model/api_json.dart';
import 'package:employeeapi/service/api_service.dart';

class EditEmployeeController extends ChangeNotifier {
  final ApiService apiService = ApiService();
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController salaryController;
  late TextEditingController positionController;
  String? imageUrl;
  String? initialId;

  EditEmployeeController({required this.initialId}) {
    nameController = TextEditingController();
    ageController = TextEditingController();
    salaryController = TextEditingController();
    positionController = TextEditingController();
    // Load employee data when the controller initializes
    loadEmployeeData();
  }

  Future<void> loadEmployeeData() async {
    try {
      if (initialId != null) {
        final employee = await apiService.fetchDataById(initialId!);
        nameController.text = employee.name ?? '';
        ageController.text = employee.age?.toString() ?? '';
        salaryController.text = employee.salary ?? '';
        positionController.text = employee.position ?? '';
        imageUrl = employee.image ?? '';
      }
    } catch (error) {
      print('Error loading employee data: $error');
    }
  }

  Future<void> updateEmployeeDetails() async {
    try {
      // Get the updated values from text controllers
      final String updatedName = nameController.text;
      int? updatedAge;
      if (ageController.text.isNotEmpty) {
        updatedAge = int.tryParse(ageController.text);
        if (updatedAge == null) {
          // Handle the case where the age is not a valid integer
          print('Error: Invalid age entered. Please enter a valid integer.');
          return;
        }
      }
      final String updatedSalary = salaryController.text;
      final String updatedPosition = positionController.text;

      // Create an instance of DataModel with the updated values
      final updatedEmployee = DataModel(
        id: initialId!,
        name: updatedName,
        age: updatedAge,
        salary: updatedSalary,
        position: updatedPosition,
        image: imageUrl,
      );

      // Update the data using ApiService
      await apiService.updateData(initialId!, updatedEmployee);

      // Notify the listeners or perform any other necessary actions
      notifyListeners();
    } catch (error) {
      print('Error updating employee details: $error');
      // Handle the error, show a message, or perform other actions
    }
  }

  Future<String?> getImageUrl() async {
    // Simulate fetching image URL from network with some delay
    await Future.delayed(const Duration(seconds: 2));
    return imageUrl;
  }

  void setImageUrl(String? newImageUrl) {
    imageUrl = newImageUrl;
    notifyListeners();
  }
}
