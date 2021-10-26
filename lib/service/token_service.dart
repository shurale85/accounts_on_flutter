import 'package:mobile_projects/models/operation_result.dart';

// Simplified logic of token accessing
class TokenService {
  static String? _token;

  static void SetToken(String token) => _token ??= token;

  static OperationResult<String> GetToken() {
    if( _token == null) {
      return OperationResult<String>(error: 'No access token');
    }

    return OperationResult<String>(data: _token);
  }

  void RefreshToken() {
    //some refresh logic
  }
}