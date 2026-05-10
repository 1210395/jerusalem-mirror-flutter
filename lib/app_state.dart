import 'package:flutter/material.dart';
import 'data/costumes.dart';

class AppState extends ChangeNotifier {
  String locale = 'en';
  String? gender;
  int currentScreen = 0;
  Costume? selectedCostume;
  String? capturedPhotoPath;
  String? generatedImageUrl;

  void setLocale(String l) {
    locale = l;
    notifyListeners();
  }

  void setGender(String g) {
    gender = g;
    goToScreen(2);
  }

  void selectCostume(Costume c) {
    selectedCostume = c;
    notifyListeners();
  }

  void goToScreen(int s) {
    currentScreen = s;
    notifyListeners();
  }

  void reset() {
    gender = null;
    selectedCostume = null;
    capturedPhotoPath = null;
    generatedImageUrl = null;
    currentScreen = 0;
    notifyListeners();
  }
}
