import 'package:flutter/material.dart';
import 'package:employeeapi/model/api_json.dart';
import 'package:employeeapi/service/api_service.dart';

class EmployeeProvider extends ChangeNotifier {
  late ApiService _apiService;
  List<DataModel> _employeeData = [];
  bool _isLoading = false;

  List<DataModel> get employeeData => _employeeData;
  bool get isLoading => _isLoading;

  EmployeeProvider() {
    _apiService = ApiService();
    fetchData();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _employeeData = await _apiService.fetchData();
    } catch (error) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }
}
