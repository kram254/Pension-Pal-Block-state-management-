import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'bloc/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/pension_repository.dart';
import 'utils/routes.dart';

void main() {
  runApp(PensionApp());
}

class PensionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => PensionRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
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