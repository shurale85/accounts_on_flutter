import 'package:msal_js/msal_js.dart';

class PublicClientBuilder {
  // ApplicationId registered in Azure
  static const String clientId = '17695f90-1932-4a01-aca6-ddfdcf1a351d';
  static late PublicClientApplication _publicClientApp;

  static PublicClientApplication build() {
    _publicClientApp = PublicClientApplication(
      Configuration()
        ..auth = (BrowserAuthOptions()
          ..clientId = clientId
          ..authority = 'https://login.microsoftonline.com/flutterback.onmicrosoft.com'
          ..redirectUri = 'http://localhost:55555/')
        ..system = (BrowserSystemOptions())
    );

    return _publicClientApp;
  }
}