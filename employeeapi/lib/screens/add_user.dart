// add_employee.dart
// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:employeeapi/api/api_json.dart';
import 'package:employeeapi/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:employeeapi/api/api_service.dart';

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

  Future<void> addEmployee() async {
    try {
      // Create a new DataModel instance with the entered data
      final newEmployee = DataModel(
        name: nameController.text,
        age: int.parse(ageController.text),
        salary: salaryController.text,
        position: positionController.text,
      );

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: salaryController,
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(labelText: 'Position'),
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
    );
  }
}
