import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/public_client_builder.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:mobile_projects/views/content_view.dart';
import 'package:msal_js/msal_js.dart';
import 'package:provider/provider.dart';

const List<String> scopes = ['https://flutterback.crm4.dynamics.com/.default'];

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => NetworkService())],
      child: MyApp(),));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  PublicClientApplication publicClientApp = PublicClientBuilder.build();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isListView = false;
  AccountInfo? _user;

  final GlobalKey<ContentViewState> _key = GlobalKey();

  Future<void> _loginPopup() async {
    try {
      final response = await widget.publicClientApp
          .loginPopup(PopupRequest()..scopes = scopes);
      setState(() {
        _user = response.account;
        TokenService.SetToken(response.accessToken);
        context.read<NetworkService>().getAccounts();
      });
    } on AuthException catch (ex) {
      print('MSAL: ${ex.errorCode}:${ex.errorMessage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
        title: TextFormField(
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Search'
            )
        ),
        actions: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [ IconButton(onPressed: (){
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Filter'),
                    content: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Test Filter'),
                    ),
                    actions: [ElevatedButton(
                      child: Text('sdfasdfasdfa'),
                      onPressed: (){
                        context.read<NetworkService>().getFilteredAccounts();},
                    )],
                  );
                });
              }, icon: const Icon(Icons.filter_alt)), Text('Filter')]),
          IconButton(onPressed: (){
            _key.currentState!.updateCardView(true);
            print(isListView);
          }, icon: const Icon(Icons.view_list)),
          IconButton(onPressed: (){
            _key.currentState!.updateCardView(false);

          }, icon: const Icon(Icons.grid_view))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _user != null
          ? ContentView(key: _key)
          : Center(child: ElevatedButton(
              child: const Text('Login'),
              onPressed: _loginPopup,
            ))
      ),
    );
  }
}
