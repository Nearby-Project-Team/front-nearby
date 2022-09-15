import 'package:flutter/material.dart';
import 'package:front_nearby/pages/auth_page.dart';
import 'package:front_nearby/pages/home_page.dart';

class PageNotifier extends ChangeNotifier{
  String _currentPage = AuthPage.pageName;

  String get currentPage => _currentPage;

  void goToMain()
  {
    _currentPage = HomePage.pageName;
    notifyListeners();
  }

  void goToOtherPage(String name)
  {
    _currentPage = name;
    notifyListeners();
  }

  String _userId = '';
  String get userID => _userId;

  void setUserId (id) {
    _userId = id;
  }
}