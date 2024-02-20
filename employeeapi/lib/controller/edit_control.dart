
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
        imageUrl = employee.image;

        // Load the image from the API if imageUrl is available
        if (imageUrl != null && imageUrl!.isNotEmpty) {
          final imageData = await apiService.fetchDataById(imageUrl!);
          // Assuming the API returns the image data as base64 encoded string
          imageUrl = imageUrl;
          notifyListeners();
        }
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
          image: imageUrl);

      // Update the data using ApiService
      await apiService.updateData(initialId!, updatedEmployee);

      // Notify the listeners or perform any other necessary actions
      notifyListeners();
    } catch (error) {
      print('Error updating employee details: $error');
      // Handle the error, show a message, or perform other actions
    }
  }

  // Function to pick an image from the gallery and convert it to base64
  Future<String?> pickImageAndConvertToBase64() async {
    // Here you would implement the code to pick an image from the gallery
    // and convert it to base64. For demonstration, I'll just return a sample base64 string.
    return 'sampleBase64String';
  }

  void setImageUrl(String? newImageUrl) {
    imageUrl = newImageUrl;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up the text controllers when the controller is disposed
    nameController.dispose();
    ageController.dispose();
    salaryController.dispose();
    positionController.dispose();
    super.dispose();
  }
}
