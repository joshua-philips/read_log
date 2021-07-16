import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridSettings extends ChangeNotifier {
  final String key = 'grid';
  late bool grid;
  late SharedPreferences prefs;

  GridSettings() {
    grid = false;
    loadFromPrefs();
  }

  Future<void> initPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
  }

  void loadFromPrefs() async {
    await initPrefs();
    grid = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  void saveToPrefs() async {
    await initPrefs();
    prefs.setBool(key, grid);
  }

  void toggleGrid() {
    grid = !grid;
    saveToPrefs();
    notifyListeners();
  }
}
