
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/views/login_page.dart';
import 'package:mobile_projects/views/main_page.dart';

const String loginPage = 'login';
const String mainPage = 'main';

Route<dynamic> controller(RouteSettings settings) {
  switch(settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (ctx) => LoginPage());
    default:
      return MaterialPageRoute(builder: (ctx) => MainPage(title: 'Flutter test app'));
  }
}