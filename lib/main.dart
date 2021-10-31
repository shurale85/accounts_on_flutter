import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/public_client_builder.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:mobile_projects/views/content_view.dart';
import 'package:mobile_projects/views/filter_view.dart';
import 'package:msal_js/msal_js.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'route/route.dart' as route;

const List<String> scopes = ['https://flutterback.crm4.dynamics.com/.default'];

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => NetworkService())],
      child: MyApp(),));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.blueGrey
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: route.controller,
      initialRoute: route.loginPage,
      //home: MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}