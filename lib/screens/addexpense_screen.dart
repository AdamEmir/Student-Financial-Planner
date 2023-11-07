import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/reusable_widgets/reusable_widget.dart';
import 'package:firstly/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  DateTime _currentDate = DateTime.now();
  TextEditingController _shoppingController = TextEditingController();
  TextEditingController _foodandbeverageController = TextEditingController();
  TextEditingController _transportationController = TextEditingController();
  TextEditingController _electronicsController = TextEditingController();
  TextEditingController _otherexpensesController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  handleSubmitExpenses() async {
    // final shopping = int.parse(_shoppingController.value.text);
    String shoppingcheck = _shoppingController.value.text;
    if (shoppingcheck.isEmpty) {
      shoppingcheck = "0";
    }
    String foodandbeveragecheck = _foodandbeverageController.value.text;
    if (foodandbeveragecheck.isEmpty) {
      foodandbeveragecheck = "0";
    }
    String transportationcheck = _transportationController.value.text;
    if (transportationcheck.isEmpty) {
      transportationcheck = "0";
    }
    String electronicscheck = _electronicsController.value.text;
    if (electronicscheck.isEmpty) {
      electronicscheck = "0";
    }
    String otherexpensescheck = _otherexpensesController.value.text;
    if (otherexpensescheck.isEmpty) {
      otherexpensescheck = "0";
    }
    final shopping = int.parse(shoppingcheck);
    final foodandbeverage = int.parse(foodandbeveragecheck);
    final transportation = int.parse(transportationcheck);
    final electronics = int.parse(electronicscheck);
    final otherexpenses = int.parse(otherexpensescheck);
    final date = _dateController.value.text;
    final User? user = auth.currentUser;
    final useremail = user?.email;

    // Get the current expenses
    final currentExpenses = await getExpenses(useremail!);
    final currentAllowance = await getAllowance(useremail!);

    final balanceAllowance = currentAllowance -
        shopping -
        foodandbeverage -
        transportation -
        electronics -
        otherexpenses;

    final expenses = currentExpenses +
        shopping +
        foodandbeverage +
        transportation +
        electronics +
        otherexpenses;

    addShopping(shopping, date, useremail!);
    addfoodandbeverage(foodandbeverage, date, useremail);
    addtransporation(transportation, date, useremail!);
    addelectronics(electronics, date, useremail!);
    addotherexpenses(otherexpenses, date, useremail!);
    addExpenses(expenses, useremail!);
    updateAllowance(balanceAllowance, date, useremail!);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));

    Fluttertoast.showToast(
      msg: 'Expenses Inserted Successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future getExpenses(String useremail) async {
    final expensesRef =
        FirebaseFirestore.instance.collection('Expenses').doc(useremail);
    final expensesDoc = await expensesRef.get();
    if (expensesDoc.exists) {
      return expensesDoc.get('expenses');
    } else {
      return 0;
    }
  }

  Future addShopping(int shopping, String date, String useremail) async {
    await FirebaseFirestore.instance.collection('Shopping').add({
      'shopping': shopping,
      'created_at': Timestamp.now(),
      'email': useremail,
    });
  }

  Future addfoodandbeverage(
      int foodandbeverage, String date, String useremail) async {
    await FirebaseFirestore.instance.collection('FoodandBeverage').add({
      'foodandbeverage': foodandbeverage,
      'created_at': Timestamp.now(),
      'email': useremail,
    });
  }

  Future addtransporation(
      int transportation, String date, String useremail) async {
    await FirebaseFirestore.instance.collection('Transportation').add({
      'Transportation': transportation,
      'created_at': Timestamp.now(),
      'email': useremail,
    });
  }

  Future addelectronics(int electronics, String date, String useremail) async {
    await FirebaseFirestore.instance.collection('Electronics').add({
      'electronics': electronics,
      'created_at': Timestamp.now(),
      'email': useremail,
    });
  }

  Future addotherexpenses(
      int otherexpenses, String date, String useremail) async {
    await FirebaseFirestore.instance.collection('OtherExpenses').add({
      'otherexpenses': otherexpenses,
      'created_at': Timestamp.now(),
      'email': useremail,
    });
  }

  Future addExpenses(int expenses, String useremail) async {
    await FirebaseFirestore.instance.collection('Expenses').doc(useremail).set({
      'expenses': expenses,
      'updated_at': Timestamp.now(),
      'email': useremail,
    });
  }

  Future getAllowance(String useremail) async {
    final expensesRef =
        FirebaseFirestore.instance.collection('Allowance').doc(useremail);
    final expensesDoc = await expensesRef.get();
    if (expensesDoc.exists) {
      return expensesDoc.get('allowance');
    } else {
      return 0;
    }
  }

  Future updateAllowance(
      int balanceAllowance, String date, String useremail) async {
    await FirebaseFirestore.instance
        .collection('Allowance')
        .doc(useremail)
        .set({
      'allowance': balanceAllowance,
      'updated_at': Timestamp.now(),
      'email': useremail,
    });
  }

  @override
  void initState() {
    super.initState();
    _dateController.text =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.teal[200],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              70,
              20,
              0,
            ),
            child: Column(children: <Widget>[
              reusableNumField(
                  "Shopping", Icons.person_outline, false, _shoppingController),
              const SizedBox(
                height: 30,
              ),
              reusableNumField("Food & Beverage", Icons.person_outline, false,
                  _foodandbeverageController),
              const SizedBox(
                height: 30,
              ),
              reusableNumField("Transportation", Icons.person_outline, false,
                  _transportationController),
              const SizedBox(
                height: 30,
              ),
              reusableNumField("Electronics", Icons.person_outline, false,
                  _electronicsController),
              const SizedBox(
                height: 30,
              ),
              reusableNumField("Other Expenses", Icons.person_outline, false,
                  _otherexpensesController),
              const SizedBox(
                height: 30,
              ),
              reusableCalenderField("Date: ${_dateController.text}",
                  Icons.calendar_month_rounded, false, _dateController),
              const SizedBox(
                height: 30,
              ),
              submitButton(context, false, () {
                handleSubmitExpenses();
              })
            ]),
          ),
        ),
      ),
    );
  }
}
