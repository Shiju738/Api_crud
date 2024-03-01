import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:employeeapi/controller/edit_control.dart';
import 'package:employeeapi/controller/home_controller.dart';
import 'package:employeeapi/views/home_page.dart';

class EditEmployee extends StatelessWidget {
  final String? initialId;

  const EditEmployee({
    Key? key,
    this.initialId,
    required this.onDataUpdated,
  }) : super(key: key);

  final VoidCallback onDataUpdated;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditEmployeeController(initialId: initialId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Employee'),
        ),
        body: _EditEmployeeForm(),
      ),
    );
  }
}

class _EditEmployeeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditEmployeeController>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Consumer<EditEmployeeController>(
              builder: (context, controller, _) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.imageUrl != null &&
                          controller.imageUrl!.isNotEmpty
                      ? MemoryImage(base64Decode(controller.imageUrl!))
                      : const AssetImage("image/dummy_1.png") as ImageProvider,
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  // Convert picked image to base64 string
                  final bytes = await pickedImage.readAsBytes();
                  final String newImageBase64 = base64Encode(bytes);
                  // Set the image URL in the controller
                  controller.setImageUrl(newImageBase64);
                }
              },
              child: const Text('Select New Image'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: controller.ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: controller.salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
            TextField(
              controller: controller.positionController,
              decoration: const InputDecoration(labelText: 'Position'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateEmployeeDetails().then((_) {
                  Provider.of<EmployeeProvider>(context, listen: false)
                      .fetchData();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                    (route) => false,
                  ).then((_) => controller);
                });
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
