// data_provider.dart

import 'package:flutter/material.dart';
import 'package:employeeapi/model/api_json.dart';
import 'package:employeeapi/service/api_service.dart';

class DataProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<DataModel> _data = [];
  List<DataModel> get data => _data;

  Future<void> fetchData() async {
    _data = await _apiService.fetchData();
    notifyListeners();
  }
}
