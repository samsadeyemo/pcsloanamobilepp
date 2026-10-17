class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Thrown when the refresh token is missing or rejected by the server,
/// meaning the user must log in again with their password.
class SessionExpiredException extends ApiException {
  SessionExpiredException([
    super.message = 'Your session has expired. Please login with your password.',
  ]);
}
