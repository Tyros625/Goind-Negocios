import 'package:flutter/material.dart';

class MenuModel {
  String icon;
  String title;
  String route;
  bool isBlocked;
  bool isNotSubscribe;
  bool isLanguage;
  Color? iconColor;

  MenuModel({required this.icon, required this.title, required this.route, this.isBlocked = false, this.isNotSubscribe = false, this.iconColor, this.isLanguage = false});
}