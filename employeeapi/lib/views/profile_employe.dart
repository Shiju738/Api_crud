import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:employeeapi/model/api_json.dart';
import 'package:employeeapi/service/api_service.dart';
import 'package:employeeapi/components/employe_card.dart';
import 'package:employeeapi/views/edit_employee.dart';
import 'package:employeeapi/views/home_page.dart';

class ProfilePage extends StatefulWidget {
  final String? employeeId;
  final Function()? onDataUpdated;

  const ProfilePage({Key? key, this.employeeId, this.onDataUpdated})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ApiService apiService = ApiService();
  DataModel? employeeData;

  @override
  void initState() {
    super.initState();
    loadEmployeeData();
  }

  Future<void> loadEmployeeData() async {
    try {
      final employee = await apiService.fetchDataById(widget.employeeId!);
      setState(() {
        employeeData = employee;
      });
      widget.onDataUpdated?.call();
    } catch (error) {
      print('Error loading employee data: $error');
    }
  }

  Future<void> deleteEmployee() async {
    try {
      await apiService.deleteDataById(widget.employeeId!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } catch (error) {
      print('Error deleting employee: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    initialId: employeeData?.id,
                    onDataUpdated: () {
                      loadEmployeeData();
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
                        deleteEmployee().then((_) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                            (route) => false,
                          );
                        });
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
                if (employeeData?.image != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(
                        base64Decode(employeeData!.image!),
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
                    value: employeeData?.name ?? 'No Name',
                  ),
                  const SizedBox(height: 16),
                  DetailCard(
                    title: 'Age',
                    value: employeeData?.age.toString() ?? 'No Age',
                  ),
                  const SizedBox(height: 16),
                  DetailCard(
                    title: 'Salary',
                    value: employeeData?.salary ?? 'No Salary',
                  ),
                  const SizedBox(height: 16),
                  DetailCard(
                    title: 'Position',
                    value: employeeData?.position ?? 'No Position',
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
