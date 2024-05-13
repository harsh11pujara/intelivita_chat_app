import 'package:flutter/material.dart';

Widget profileElements({required String title, required String subtitle}) {
  return ListTile(

    title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 18),),
  );
}