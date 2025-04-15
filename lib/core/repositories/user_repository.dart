import 'package:http/http.dart' as http;
import 'package:test_app/core/core.dart';

/// {@template user_repository_exception}
/// General exception for [UserRepository] methods.
/// {@endtemplate}
class UserException implements Exception {
  /// {@macro user_repository_exception}
  const UserException({String? message})
      : message = message ?? 'Something went wrong';

  /// Error message.
  final String? message;

  @override
  String toString() => message!;
}

/// {@template user_repository}
/// User repository interacts with the user API.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required String baseUrl,
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _client = client ?? http.Client();

  final http.Client _client;
  final String _baseUrl;

  /// Get users endpoint endpoint
  String _getUsersEndpoint() => '$_baseUrl/users';

  /// Get users
  ///
  /// Returns list of [User] on success.
  /// Throws [UserException] when operation fails.
  Future<List<User>> getUsers() async {
    try {
      final url = _getUsersEndpoint();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      return await APIHelper.request<List<User>>(
        request: _client.get(
          Uri.parse(url),
          headers: headers,
        ),
        onSuccessList: (value) => value.map((e) => User.fromJson(e)).toList(),
      );
    } on APIException catch (e) {
      throw UserException(message: e.message);
    } catch (e) {
      throw const UserException();
    }
  }
}
