import 'package:flutter/material.dart';

Widget profileElements({required String title, required String subtitle, double? subtitleSize}) {
  return ListTile(
    title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle, style: TextStyle(fontSize: subtitleSize ?? 18),),
  );
}