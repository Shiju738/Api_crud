import 'dart:convert';

import 'package:employeeapi/controller/home_controller.dart';
import 'package:employeeapi/controller/profile_controller.dart';
import 'package:employeeapi/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:employeeapi/components/employe_card.dart';
import 'package:employeeapi/views/edit_employee.dart';
import 'package:employeeapi/model/api_json.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String? employeeId;

  const ProfilePage({Key? key, this.employeeId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profileController =
        Provider.of<ProfileController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEmployee(
                    onDataUpdated: () {},
                    initialId: widget.employeeId,
                  ),
                ),
              ).then((_) {
                profileController
                    .fetchEmployeeById(widget.employeeId!)
                    .then((_) {
                  // Update UI if necessary
                });
              });
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DataModel?>(
        future: profileController.fetchEmployeeById(widget.employeeId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final employeeData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (employeeData.image != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(
                              base64Decode(employeeData.image!),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailCard(
                          title: 'Name',
                          value: employeeData.name ?? 'No Name',
                        ),
                        const SizedBox(height: 16),
                        DetailCard(
                          title: 'Age',
                          value: employeeData.age.toString(),
                        ),
                        const SizedBox(height: 16),
                        DetailCard(
                          title: 'Salary',
                          value: employeeData.salary ?? 'No Salary',
                        ),
                        const SizedBox(height: 16),
                        DetailCard(
                          title: 'Position',
                          value: employeeData.position ?? 'No Position',
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: const Text(
                                      "Are you sure you want to delete this employee?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        profileController.deleteEmployeeById(
                                            widget.employeeId!);
                                        Provider.of<EmployeeProvider>(context,
                                                listen: false)
                                            .fetchData();
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("Delete"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
