import 'package:employeeapi/controller/home_controller.dart';
import 'package:employeeapi/views/add_user.dart';
import 'package:employeeapi/views/profile_employe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, _) {
          if (employeeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (employeeProvider.employeeData.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: employeeProvider.employeeData.length,
              itemBuilder: (context, index) {
                final data = employeeProvider.employeeData[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        'Name: ${data.name ?? 'No Name'}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Age: ${data.age ?? 0}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              employeeId: data.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployee(),
            ),
          );
        },
        tooltip: 'Add Employee',
        child: const Icon(Icons.add),
      ),
    );
  }
}
