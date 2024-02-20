// ignore_for_file: use_build_context_synchronously, avoid_print, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:io';
import 'package:employeeapi/controller/add_employee_controller.dart';

import 'package:employeeapi/service/api_service.dart';

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
                  onPressed: () {
                    EmployeeManager.addEmployee(
                      formKey: _formKey,
                      nameController: nameController,
                      ageController: ageController,
                      salaryController: salaryController,
                      positionController: positionController,
                      imagee: _image,
                      context: context,
                      apiService: ApiService(),
                    );
                  },
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
