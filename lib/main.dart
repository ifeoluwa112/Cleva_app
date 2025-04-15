import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/app/app_bloc_observer.dart';
import 'package:test_app/app/app_locator.dart';
import 'package:test_app/features/features.dart';

Future<void> main() async {
  /// Initialize widgets flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  /// Setting preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Setting up dependency injection
  await setUpLocator();

  // Setting up Bloc observer
  Bloc.observer = AppBlocObserver();

  // Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cleva Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        lazy: false,
        create: (context) => UserBloc()..add(UserEvent.getUsers()),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Test Users'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return state.maybeMap(
            loading: (value) {
              return Center(child: Text('Loading'));
            },
            loaded: (value) {
              return SingleChildScrollView(
                child: Column(
                  children: value.user
                      .map((user) => ListTile(
                            title: Text(user.name),
                            subtitle: Text(user.email),
                          ))
                      .toList(),
                ),
              );
            },
            error: (value) {
              return Center(child: Text(value.error ?? ''));
            },
            orElse: SizedBox.shrink,
          );
        },
      ),
    );
  }
}
