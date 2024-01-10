import 'package:firebase_core/firebase_core.dart';
import 'package:firstly/firebase_options.dart';
import 'package:firstly/screens/onboarding_screen.dart';
import 'package:firstly/screens/resetpassword_screen.dart';
import 'package:firstly/screens/siginintest.dart';
import 'package:flutter/material.dart';
import 'screens/signin_screen.dart';
import 'screens/list_other_expenses_screen.dart';
import 'screens/list_shopping_screen.dart';
import 'screens/list_electronic_screen.dart';
import 'screens/list_transportation_screen.dart';
import 'screens/list_food_and_beverage_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
          // Your app's theme configuration
          ),
      initialRoute: '/onboarding', // Set the initial route
      routes: {
        '/signin': (context) => const SigninTestScreen(),
        '/resetpassword': (context) => const ResetPasswordScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/listotherexpenses': (context) => ListOtherExpensesScreen(),
        '/listshopping': (context) => ListShoppingScreen(),
        '/listelectronic': (context) => ListElectronicScreen(),
        '/listtransportation': (context) => ListTransportationScreen(),
        '/listfoodandbeverage': (context) => ListFoodAndBeverageScreen(),
        // ... other routes ...
      },
    );
  }
}
