import 'package:get_it/get_it.dart';
import 'package:test_app/core/core.dart';

/// Global [GetIt.instance].
final locator = GetIt.instance;

/// Set up [GetIt] locator.
Future<void> setUpLocator() async {
  final baseUrl = 'https://jsonplaceholder.typicode.com';
  locator.allowReassignment = true;
  locator.registerSingleton<UserRepository>(
    UserRepository(baseUrl: baseUrl),
  );
}
