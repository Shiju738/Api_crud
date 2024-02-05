// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

// }import 'package:employeeapi/api/api_json.dart';
import 'package:employeeapi/api/api_json.dart';
import 'package:employeeapi/api/api_service.dart';
import 'package:employeeapi/const/employe_card.dart';
import 'package:employeeapi/screens/edit_employee.dart';
import 'package:employeeapi/screens/home_page.dart';
import 'package:flutter/material.dart';

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
  DataModel? employeeData; // Allow employeeData to be null initially

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
      // Invoke the onDataUpdated callback if provided
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
          ));
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
                      loadEmployeeData(); // Refresh the profile page after data update
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
                        Navigator.of(context).pop(); // Close the dialog
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
                            (route) =>
                                false, // Remove all routes from the stack
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
        child: Padding(
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
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
