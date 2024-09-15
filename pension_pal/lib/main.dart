import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'utils/routes.dart';

void main() {
  runApp(PensionApp());
}

class PensionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: MaterialApp(
          title: 'Pension App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: Routes.login,
          routes: Routes.routes,
        ),
      ),
    );
  }
}