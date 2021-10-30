import 'package:flutter/cupertino.dart';
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/views/card_view.dart';
import 'package:provider/src/provider.dart';

import 'splash_screen.dart';
import 'car_grid_viw.dart';

class ContentView extends StatefulWidget {
  bool isListView = false;
  ContentView({Key? key}) : super(key: key);
  @override
  ContentViewState createState() => ContentViewState();
}

class ContentViewState extends State<ContentView> {
  bool isListView = false;
  //Future<List<Account>?> accountsFuture = NetworkService.getAccounts();
  ContentViewState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    List<Account> accounts = context.watch<NetworkService>().getData();
        return context.watch<NetworkService>().getIsLoading()
          ? const SplashScreen()
          : Center(child:
            isListView
              ? ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (context, index){
                      return Container(
                        height: 200,//MediaQuery.of(context).size.height,
                        margin: EdgeInsets.all(2),
                        child: CardView(accounts[index]),
                      );
                    })
                  : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3/2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
                  itemCount: accounts.length,
                  itemBuilder: (BuildContext context, index){
                  return CardGridView(accounts[index]);
                 }));
          }

  updateCardView(bool isListViewSelected) {
    if(isListView != isListViewSelected) {
      setState((){
        isListView = isListViewSelected;
      });
  }}
}