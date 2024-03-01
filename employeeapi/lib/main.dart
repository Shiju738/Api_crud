import 'dart:io';
import 'package:employeeapi/controller/edit_control.dart';
import 'package:employeeapi/controller/home_controller.dart';
import 'package:employeeapi/controller/image_picker.dart';
import 'package:employeeapi/controller/login_provider.dart';
import 'package:employeeapi/controller/profile_controller.dart';
import 'package:employeeapi/service/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:employeeapi/auth/auth.dart';
import 'package:employeeapi/firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EmployeeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginRegisterModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ApiService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageProviders(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditEmployeeController(initialId: ''),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(158, 158, 158, 1)),
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey, errorColor: Colors.red),
      ),
      home: const AuthPage(),
    );
  }
}
