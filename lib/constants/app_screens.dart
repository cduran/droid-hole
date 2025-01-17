import 'package:flutter/material.dart';

import 'package:droid_hole/screens/domains.dart';
import 'package:droid_hole/screens/settings.dart';
import 'package:droid_hole/screens/connect.dart';
import 'package:droid_hole/screens/home.dart';
import 'package:droid_hole/screens/logs.dart';
import 'package:droid_hole/screens/statistics.dart';

import 'package:droid_hole/models/app_screen.dart';

final List<AppScreen> appScreens = [
  const AppScreen(
    icon: Icon(Icons.home), 
    name: "home", 
    widget: Home(),
  ),
  const AppScreen(
    icon: Icon(Icons.analytics_rounded), 
    name: "statistics", 
    widget: Statistics(),
  ),
  const AppScreen(
    icon: Icon(Icons.list_alt_rounded), 
    name: "logs", 
    widget: Logs(),
  ),
  const AppScreen(
    icon: Icon(Icons.shield_rounded), 
    name: "domains", 
    widget: DomainLists(),
  ),
  const AppScreen(
    icon: Icon(Icons.settings), 
    name: "settings", 
    widget: Settings(),
  ),
];

final List<AppScreen> appScreensNotSelected = [
  const AppScreen(
    icon: Icon(Icons.link_rounded), 
    name: "connect", 
    widget: Connect(),
  ),
  const AppScreen(
    icon: Icon(Icons.settings), 
    name: "settings", 
    widget: Settings(),
  ),
];
