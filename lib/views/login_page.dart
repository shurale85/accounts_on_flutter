import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/service/public_client_builder.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:msal_js/msal_js.dart';
import 'package:mobile_projects/route/route.dart' as route;
import 'package:provider/provider.dart';

const List<String> scopes = ['https://flutterback.crm4.dynamics.com/.default'];

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  final PublicClientApplication publicClientApp = PublicClientBuilder.build();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _loginPopup() async {
    try {
      final response = await widget.publicClientApp
          .loginPopup(PopupRequest()..scopes = scopes);
      setState(() {
        context.read<TokenService>().setToken(response.accessToken);
        Navigator.pushNamed(context, route.mainPage);
      });
    } on AuthException catch (ex) {
      print('MSAL: ${ex.errorCode}:${ex.errorMessage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Center(child: ElevatedButton(
    child: const Text('Login'),
    onPressed: _loginPopup,
    )
    );
  }
}
