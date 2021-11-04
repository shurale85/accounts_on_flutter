import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:provider/provider.dart';
import 'models/filter_state.dart';
import 'route/route.dart' as route;

const List<String> scopes = ['https://flutterback.crm4.dynamics.com/.default'];

///Entry point for integration test that allows to skip login page
// This entry point is a workaround for testing purpose since it is not available to set initial route flutter build web command
// see https://github.com/flutter/flutter/issues/58980
void main(List<String> args,
    [NetworkService? networkService, Repository? repository]) {
  runApp(MultiProvider(
    providers: [
      Provider<Repository?>(create: (_) => repository),
      Provider<FilterState>(create: (_) => FilterState.create()),
      Provider<TokenService>(create: (_) => TokenService()),
      ChangeNotifierProvider(
          create: (ctx) =>
              networkService ??
              NetworkService(
                  repository: ctx.read<Repository>(),
                  tokenService: ctx.read<TokenService>())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.blueGrey),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: route.controller,
        initialRoute: route.mainPage);
  }
}
