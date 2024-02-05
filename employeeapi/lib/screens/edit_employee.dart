// edit_employee.dart

// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:employeeapi/api/api_json.dart';
import 'package:employeeapi/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:employeeapi/api/api_service.dart';

class EditEmployee extends StatefulWidget {
  final String? initialId;
  final Function? onDataUpdated;

  const EditEmployee({
    this.initialId,
    this.onDataUpdated,
    Key? key,
  }) : super(key: key);

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final ApiService apiService = ApiService();
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController salaryController;
  late TextEditingController positionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    salaryController = TextEditingController();
    positionController = TextEditingController();
    // Load employee data when the screen initializes
    loadEmployeeData();
  }

  Future<void> loadEmployeeData() async {
    try {
      if (widget.initialId != null) {
        final employee = await apiService.fetchDataById(widget.initialId!);
        setState(() {
          nameController.text = employee.name ?? '';
          ageController.text = employee.age?.toString() ?? '';
          salaryController.text = employee.salary ?? '';
          positionController.text = employee.position ?? '';
        });
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
        name: updatedName,
        age: updatedAge,
        salary: updatedSalary,
        position: updatedPosition,
      );

      // Update the data using ApiService
      await apiService.updateData(widget.initialId!, updatedEmployee);

      // Notify the parent widget or perform any other necessary actions
      if (widget.onDataUpdated != null) {
        widget.onDataUpdated!();
      }

      // Navigate back or perform other UI changes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
        (route) => false, // Remove all routes from the stack
      );
    } catch (error) {
      print('Error updating employee details: $error');
      // Handle the error, show a message, or perform other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
              keyboardType: TextInputType.number,
              maxLength: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: salaryController,
              decoration: const InputDecoration(
                labelText: 'Salary',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(
                labelText: 'Position',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update employee details when the button is pressed
                updateEmployeeDetails();
              },
              child: const Text('Update Employee'),
            ),
          ],
        ),
      ),
    );
  }
}
