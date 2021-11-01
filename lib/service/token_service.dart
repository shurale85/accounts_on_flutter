import 'package:mobile_projects/models/operation_result.dart';

/// Simplified logic of token storing
class TokenService {
  static String? _token;

  TokenService();

  void setToken(String token) => _token ??= token;

  OperationResult<String> getToken() {
    if( _token == null) {
      return OperationResult<String>(error: 'No access token');
    }

    return OperationResult<String>(data: _token);
  }
}