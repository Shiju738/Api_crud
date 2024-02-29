// ProfileController.dart
import 'package:employeeapi/model/api_json.dart';
import 'package:employeeapi/service/api_service.dart';
import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<DataModel?> fetchEmployeeById(String employeeId) {
    return _apiService.fetchDataById(employeeId);
  }

  Future<void> deleteEmployeeById(String employeeId) {
    return _apiService.deleteDataById(employeeId);
  }
}
