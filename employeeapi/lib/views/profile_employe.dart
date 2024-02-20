// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:employeeapi/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:employeeapi/components/employe_card.dart';
import 'package:employeeapi/views/edit_employee.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String? employeeId;

  const ProfilePage({Key? key, this.employeeId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(
      employeeId: widget.employeeId!,
      onDataUpdated: () {
        setState(() {});
      },
      onUpdate: () {},
      onDelete: () {},
    );
    _controller.loadEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(employeeId: widget.employeeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Profile'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEmployee(
                      initialId: _controller.employeeData?.id,
                      onDataUpdated: () {
                        _controller.loadEmployeeData();
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Employee?'),
                    content: const Text(
                        'Are you sure you want to delete this employee?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _controller.deleteEmployee(context);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_controller.employeeData?.image != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(
                          base64Decode(_controller.employeeData!.image!),
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
                      value: _controller.employeeData?.name ?? 'No Name',
                    ),
                    const SizedBox(height: 16),
                    DetailCard(
                      title: 'Age',
                      value:
                          _controller.employeeData?.age.toString() ?? 'No Age',
                    ),
                    const SizedBox(height: 16),
                    DetailCard(
                      title: 'Salary',
                      value: _controller.employeeData?.salary ?? 'No Salary',
                    ),
                    const SizedBox(height: 16),
                    DetailCard(
                      title: 'Position',
                      value:
                          _controller.employeeData?.position ?? 'No Position',
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
