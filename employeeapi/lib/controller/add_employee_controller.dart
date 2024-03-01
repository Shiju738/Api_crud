// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:employeeapi/model/api_json.dart';
import 'package:employeeapi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Your existing EmployeeManager class extending ChangeNotifier
class EmployeeManager extends ChangeNotifier {
  Future<void> addEmployee({
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
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        final newEmployee = DataModel(
          name: nameController.text,
          age: int.parse(ageController.text),
          salary: salaryController.text,
          position: positionController.text,
        );

        final bytes = await imagee!.readAsBytes();
        final imageBase64 = base64Encode(bytes);
        newEmployee.image = imageBase64;

        await apiService.addData(newEmployee);

        // Notify listeners that a change has occurred
        notifyListeners(); // This will trigger a rebuild of listening widgets

        // Navigate back to the employee list page
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error adding employee: $error');
    }
  }

  File? _image;

  File? get image => _image;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = File(image.path);
      notifyListeners(); // Notify listeners about the change
    }
  }
}
