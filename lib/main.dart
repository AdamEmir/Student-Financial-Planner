import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firstly/screens/signin_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SignInScreen());
  }
}

  // if (totalExpense == 0.00) {}

  //   if (dropdownValue == 'Shopping') {
  //     piedataCalculation =
  //         ((totalShopping + transactionAmount) * 5) / totalExpense;
  //     piedataNumber = piedataCalculation.toInt();
  //     piedataString = piedataNumber.toString();
  //     setPiechartdata(
  //         piedataNumber, piedataString, useremail!, piedataCategory);
  //   } else if (dropdownValue == 'Electronic') {
  //     piedataCalculation =
  //         ((totalElectronic + transactionAmount) * 5) / totalExpense;
  //     piedataNumber = piedataCalculation.toInt();
  //     piedataString = piedataNumber.toString();
  //     setPiechartdata(
  //         piedataNumber, piedataString, useremail!, piedataCategory);
  //   }





    // // If the piechartdata collection is empty, initialize it with the current transaction
    // QuerySnapshot pieChartDataSnapshot = await FirebaseFirestore.instance
    //     .collection('piechartdata')
    //     .where('email', isEqualTo: useremail)
    //     .get();

    // if (pieChartDataSnapshot.docs.isEmpty) {
    //   // If piechartdata collection is empty, determine the initial category based on the user's first transaction
    //   String initialCategory =
    //       dropdownValue; // You may need to adjust this based on how you determine the initial category
    //   await setInitialPieChartData(useremail!, initialCategory);
    // }



    // Future<void> setInitialPieChartData(
  //     String useremail, String initialCategory) async {
  //   final Map<String, dynamic> initialData = {
  //     '$initialCategory percent': 100,
  //     '$initialCategory title': '100',
  //     'updated at': Timestamp.now(),
  //     'email': useremail,
  //   };

  //   // Initialize other categories with 0 percent and 0 title
  //   final List<String> categories = [
  //     'Shopping',
  //     'Electronic',
  //     'Transportation',
  //     'FoodandBeverage',
  //     'OtherExpenses',
  //   ];

  //   for (String category in categories) {
  //     if (category != initialCategory) {
  //       initialData['$category percent'] = 0;
  //       initialData['$category title'] = '0';
  //     }
  //   }

  //   await FirebaseFirestore.instance
  //       .collection('piechartdata')
  //       .doc(useremail)
  //       .set(initialData, SetOptions(merge: true));
  // }
