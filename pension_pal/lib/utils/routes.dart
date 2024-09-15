   import 'package:flutter/material.dart';
   import '../ui/screens/login_screen.dart';
   import '../ui/screens/dashboard_screen.dart';
   import '../ui/screens/pension_detail_screen.dart';
   // Import other screens as needed

   class Routes {
     static const String login = '/';
     static const String dashboard = '/dashboard';
     static const String pensionDetail = '/pension_detail';
     // Define other routes

     static Map<String, WidgetBuilder> get routes => {
           login: (context) => LoginScreen(),
           dashboard: (context) => DashboardScreen(),
           pensionDetail: (context) {
             final args = ModalRoute.of(context)!.settings.arguments as String;
             return PensionDetailScreen(pensionId: args);
           },
           // Add other routes
         };
   }