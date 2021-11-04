import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/public_client_builder.dart';
import 'package:mobile_projects/views/content_view.dart';
import 'package:mobile_projects/views/filter_view.dart';
import 'package:msal_js/msal_js.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);
  final String title;
  final PublicClientApplication publicClientApp = PublicClientBuilder.build();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isListView = false;
  final GlobalKey<ContentViewState> _key = GlobalKey();

  @override
  void initState() {
    searchOnChange.debounceTime(const Duration(seconds: 1)).listen((query) {
      context.read<NetworkService>().searchAccount(query);
    });
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => context.read<NetworkService>().getAccounts());
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
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.search), key: const Key('searchIconKey')),
          title: TextField(
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(7),
                fillColor: Colors.white60,
                filled: true,
                border: OutlineInputBorder(),
                labelText: 'Search'),
            onChanged: _search,
            controller: textEditingController,
            key: const Key('searchTextFiledKey'),
          ),
          actions: [
            Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  IconButton(
                      key: const Key('filterIconKey'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FilterView();
                            });
                      },
                      icon: const Icon(Icons.filter_alt)),
                  const Text('Filter')
                ]),
            IconButton(
                key: const Key('listIconKey'),
                onPressed: () {
                  _key.currentState!.updateCardView(true);
                },
                icon: const Icon(Icons.view_list)),
            IconButton(
                key: const Key('gridIconKey'),
                onPressed: () {
                  _key.currentState!.updateCardView(false);
                },
                icon: const Icon(Icons.grid_view))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(20), child: ContentView(key: _key)));
  }
}
