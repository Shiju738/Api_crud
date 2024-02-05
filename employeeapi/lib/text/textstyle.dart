// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';

class TestStyle extends StatelessWidget {
  String name;
  Color? color;
  FontWeight? fw;
  FontStyle? fs;
  double? FontSize;
  TestStyle(
      {super.key,
      this.color,
      this.fs,
      required this.name,
      this.fw,
      this.FontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontStyle: fs, fontWeight: fw, color: color, fontSize: FontSize),
    );
  }
}
