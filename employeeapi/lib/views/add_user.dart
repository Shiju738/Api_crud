// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:employeeapi/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:employeeapi/controller/add_employee_controller.dart';
import 'package:employeeapi/service/api_service.dart';
import 'package:employeeapi/views/home_page.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmployeeManager(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Employee'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Consumer<EmployeeManager>(
                builder: (context, employeeManager, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: employeeManager.pickImage,
                        child: const Text('Pick Image'),
                      ),
                      const SizedBox(height: 10),
                      if (employeeManager.image != null)
                        Image.file(
                          employeeManager.image!,
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
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: positionController,
                        decoration:
                            const InputDecoration(labelText: 'Position'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a position';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          await employeeManager.addEmployee(
                            formKey: _formKey,
                            nameController: nameController,
                            ageController: ageController,
                            salaryController: salaryController,
                            positionController: positionController,
                            imagee: employeeManager.image,
                            context: context,
                            apiService: ApiService(),
                          );
                          Provider.of<EmployeeProvider>(context, listen: false)
                              .fetchData();

                          // Navigate back to the home screen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Add Employee'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
