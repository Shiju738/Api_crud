import 'dart:convert';
import 'dart:io';

import 'package:employeeapi/service/api_json.dart';
import 'package:employeeapi/service/api_service.dart';
import 'package:employeeapi/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  // Define a GlobalKey for the Form widget
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define a File object to store the selected image
  File? _image;

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> addEmployee() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Create a new DataModel instance with the entered data
        final newEmployee = DataModel(
          name: nameController.text,
          age: int.parse(ageController.text),
          salary: salaryController.text,
          position: positionController.text,
        );

        // Convert the selected image to base64 string
        final bytes = await _image!.readAsBytes();
        final imageBase64 = base64Encode(bytes);

        // Add the image to the DataModel
        newEmployee.image = imageBase64;

        // Call the API service to add the new employee
        await apiService.addData(newEmployee);

        // Navigate back to the employee list page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
          (route) => false, // Remove all routes from the stack
        );
      }
    } catch (error) {
      print('Error adding employee: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add a button to pick an image
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 10),

                // Display the selected image if available
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                  ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an age';
                    }
                    // You can add more specific validation for age if needed
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: salaryController,
                  decoration: const InputDecoration(labelText: 'Salary'),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a salary';
                    }
                    // You can add more specific validation for salary if needed
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: 'Position'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a position';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addEmployee,
                  child: const Text('Add Employee'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}