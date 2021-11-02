# accounts_on_flutter

SPA to view accounts from Dynamic 365 CRM that is developed on flutter.
# active features
 - Authentication and authorization via Azure platform
 - Requesting accounts
 - Displaying accounts on list and grid view
 - Filtering by AccountState and ProvinceOrCity fields
 - Searching by AccountNamr and AccountNumber fields

# requirements
- Port 55555 has to be used to launc application
- Guest user one@flutterback.onmicrosoft.com / nopas@r@n123 can be used to play around

# running
 Launch build_run.cmd file that will male web application available by http://localhost:555555

This project is a starting point for a Flutter application and not suposed to be considered as best practices or production-ready-template.

# testing
generating mock: dart run build_runner build. Generated mocks has to be used in order to use when/then/verify methods of Mock. If mock object are created manually
it is not possible to set and verify mock behaviour.
ui test can be run by command: *flutter drive --debug --driver=test/test_driver/integration_test.dart --target=test/ui_test/widget_test.dart*
integration test run command: *flutter drive --debug --driver=test/test_driver/integration_test.dart --target=test/integration_test/application_test.dart*.
It is under construction.
