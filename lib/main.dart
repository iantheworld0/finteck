import 'package:fintecks/models/transaction_model.dart';
import 'package:fintecks/pages/charges/Charge_Det.dart';
import 'package:fintecks/pages/home/HomeScreen.dart';
import 'package:fintecks/pages/navbotom.dart/bottomnavigationbar.dart';
import 'package:fintecks/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transactionsBox');
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
  
}
