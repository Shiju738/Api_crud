import 'package:employeeapi/controller/login_provider.dart';
import 'package:employeeapi/views/login_page.dart';
import 'package:employeeapi/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginOrRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginRegisterModel>(
      builder: (context, model, child) {
        if (model.showLoginPage) {
          return LoginPage(onTab: model.togglePages);
        } else {
          return RegisterPage(onTab: model.togglePages);
        }
      },
    );
  }
}
