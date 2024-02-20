// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:employeeapi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:employeeapi/model/api_json.dart';
import 'package:employeeapi/views/home_page.dart';

class ProfileController extends ChangeNotifier {
  final String? employeeId;
  final Function()? onDataUpdated;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  ProfileController({
    this.employeeId,
    this.onDataUpdated,
    this.onUpdate,
    this.onDelete,
  });

  final ApiService apiService = ApiService();
  DataModel? employeeData;

  Future<void> loadEmployeeData() async {
    try {
      final employee = await apiService.fetchDataById(employeeId!);
      employeeData = employee;
      onDataUpdated?.call();
    } catch (error) {
      print('Error loading employee data: $error');
    }
  }

  Future<void> deleteEmployee(BuildContext context) async {
    try {
      await apiService.deleteDataById(employeeId!);
      onDelete!();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
        (route) => false,
      );
    } catch (error) {
      print('Error deleting employee: $error');
    }
  }
}
