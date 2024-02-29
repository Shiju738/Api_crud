
import 'dart:io';

import 'package:flutter/material.dart';

class ImageProviders extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  void setImage(File file) {
    _image = file;
    notifyListeners();
  }
}
