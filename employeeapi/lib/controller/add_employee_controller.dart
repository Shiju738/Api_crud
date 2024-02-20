// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:employeeapi/model/api_json.dart';
import 'package:flutter/material.dart';
import 'package:employeeapi/service/api_service.dart';
import 'package:employeeapi/views/home_page.dart';

class EmployeeManager {
  static Future<void> addEmployee({
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController ageController,
    required TextEditingController salaryController,
    required TextEditingController positionController,
    required dynamic imagee,
    required BuildContext context,
    required ApiService apiService,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        // Create a new DataModel instance with the entered data
        final newEmployee = DataModel(
          name: nameController.text,
          age: int.parse(ageController.text),
          salary: salaryController.text,
          position: positionController.text,
        );

        // Convert the selected image to base64 string
        final bytes = await imagee!.readAsBytes();
        final imageBase64 = base64Encode(bytes);

        // Add the image to the DataModel
        newEmployee.image = imageBase64;

        // Call the API service to add the new employee
        await apiService.addData(newEmployee);

        // Navigate back to the employee list page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
          (route) => false, // Remove all routes from the stack
        );
      }
    } catch (error) {
      print('Error adding employee: $error');
    }
  }
}

class ImageProvider extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  void setImage(File image) {
    _image = image;
    notifyListeners();
  }
}
