import 'package:fintecks/pages/charges/Charge_Det.dart';
import 'package:fintecks/routes/app_router.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: _appRouter.generateRoute,
      // initialRoute: '/',
      home: Charges()
    );
  }
  
  // // Configuration des langues (Nécessaire pour le calendrier ET pour éviter l'erreur)
  //     localizationsDelegates: const [
  //       GlobalMaterialLocalizations.delegate,
  //       GlobalWidgetsLocalizations.delegate,
  //       GlobalCupertinoLocalizations.delegate,
  //     ],
  //     supportedLocales: const [
  //       Locale('fr', 'FR'),
  //     ],
}
