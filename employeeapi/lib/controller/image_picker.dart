import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


Future<String?> pickImageAndConvertToBase64() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
  if (imageFile != null) {
    final File file = File(imageFile.path);
    final List<int> imageBytes = await file.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
  return null;
}
