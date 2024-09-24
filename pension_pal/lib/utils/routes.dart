   import 'package:flutter/material.dart';
   import '../ui/screens/login_screen.dart';
   import '../ui/screens/dashboard_screen.dart';
   import '../ui/screens/pension_detail_screen.dart';
   import '../ui/screens/add_pension_screen.dart';
   import '../ui/screens/profile_screen.dart';
   import '../ui/screens/settings_screen.dart';
   import '../ui/screens/help_screen.dart';

   class Routes {
     static const String login = '/';
     static const String dashboard = '/dashboard';
     static const String pensionDetail = '/pension_detail';
     static const String addPension = '/add_pension';
     static const String profile = '/profile';
     static const String settings = '/settings';
     static const String help = '/help';

     static Route<dynamic> generateRoute(RouteSettings settings) {
       switch (settings.name) {
         case login:
           return MaterialPageRoute(builder: (_) => LoginScreen());
         case dashboard:
           return MaterialPageRoute(builder: (_) => DashboardScreen());
         case pensionDetail:
           final args = settings.arguments as String;
           return MaterialPageRoute(
             builder: (_) => PensionDetailScreen(pensionId: args),
           );
         case addPension:
           return MaterialPageRoute(builder: (_) => AddPensionScreen());
         case profile:
           return MaterialPageRoute(builder: (_) => ProfileScreen());
         case settings:
           return MaterialPageRoute(builder: (_) => SettingsScreen());
         case help:
           return MaterialPageRoute(builder: (_) => HelpScreen());
         default:
           return MaterialPageRoute(
             builder: (_) => Scaffold(
               body: Center(
                 child: Text('No route defined for ${settings.name}'),
               ),
             ),
           );
       }
     }

     static Map<String, WidgetBuilder> get routes => {
       login: (context) => LoginScreen(),
       dashboard: (context) => DashboardScreen(),
       addPension: (context) => AddPensionScreen(),
       profile: (context) => ProfileScreen(),
       settings: (context) => SettingsScreen(),
       help: (context) => HelpScreen(),
     };
   }