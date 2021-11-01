import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:provider/provider.dart';
import 'route/route.dart' as route;

const List<String> scopes = ['https://flutterback.crm4.dynamics.com/.default'];

void main() {
  runApp(
      MultiProvider(providers: [
        Provider<Repository>(create: (_) => Repository()),
        ChangeNotifierProvider(create: (ctx) => NetworkService(repository: ctx.read<Repository>())),
      ],
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