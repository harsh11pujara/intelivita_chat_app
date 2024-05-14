import 'package:flutter/material.dart';

Widget profileElements(
    {required String title,
    required String subtitle,
    double? subtitleSize,
    Color? tileColor,
    AlignmentGeometry? subtitleAlignment}) {
  return ListTile(
    title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    subtitle: Align(
        alignment: subtitleAlignment ?? Alignment.centerLeft,
        child: Text(
          subtitle,
          style: TextStyle(fontSize: subtitleSize ?? 18),
        )),
    tileColor: tileColor,
  );
}
