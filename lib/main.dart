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
  // This widget is the root of your application.
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
/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  final PublicClientApplication publicClientApp = PublicClientBuilder.build();

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
        TokenService.setToken(response.accessToken);
        context.read<NetworkService>().getAccounts();

      });
    } on AuthException catch (ex) {
      print('MSAL: ${ex.errorCode}:${ex.errorMessage}');
    }
  }


  @override
  void initState() {
    searchOnChange.debounceTime(const Duration(seconds: 1)).listen((query) {
      context.read<NetworkService>().searchAccount(query);
    });
    super.initState();
  }

  final textEditingController = TextEditingController();
  bool isSearching = false;
  final searchOnChange = BehaviorSubject<String>();
  void _search(String queryString) {
    searchOnChange.add(queryString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
        title: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(7),
                fillColor: Colors.white60,
                  filled: true,
                  border: OutlineInputBorder(

                  ),
                  labelText: 'Search'
              ),
            onChanged: _search,
          controller: textEditingController,
          ),

        actions: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [ IconButton(onPressed: (){
                showDialog(context: context, builder: (BuildContext context){
                  return FilterView();
                });
              }, icon: const Icon(Icons.filter_alt)), Text('Filter')]),
          IconButton(onPressed: (){
            _key.currentState!.updateCardView(true);
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
}*/
