import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PiechartScreen extends StatefulWidget {
  const PiechartScreen({super.key});
  @override
  State<PiechartScreen> createState() => _PiechartScreenState();
}

class _PiechartScreenState extends State<PiechartScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final transactionAmountController = TextEditingController();
  String dropdownValue = 'Shopping';
  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');
  CollectionReference pieChartDataRef =
      FirebaseFirestore.instance.collection('piechartdata');

  void saveDataToFirestore(
      String dropdownValue, double transactionAmount) async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final formattedIncomeAmount = transactionAmount.toStringAsFixed(2);

    if (useremail != null) {
      try {
        await transactionsRef.add({
          'email': useremail,
          'transaction amount': formattedIncomeAmount,
          'transaction category': dropdownValue,
          'transaction date': Timestamp.now(),
          'transaction type': 'Expense',
        });

        // Update pie chart data after adding a new transaction
        updatePieChartData();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        Fluttertoast.showToast(
          msg: 'Data added Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } catch (error) {
        print('Error adding data to Firestore: $error');
        Fluttertoast.showToast(
          msg: 'Data added Failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  // Method to calculate pie chart data and update Firestore
  Future<void> updatePieChartData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;
    try {
      QuerySnapshot transactionsSnapshot = await transactionsRef.get();

      // Initialize category amounts
      double shoppingAmount = 0;
      double electronicAmount = 0;
      double transportationAmount = 0;
      double foodandbeverageAmount = 0;
      double otherexpensesAmount = 0;

      // Calculate category amounts based on transactions
      for (QueryDocumentSnapshot transaction in transactionsSnapshot.docs) {
        String category = transaction['transaction category'];
        double amount = double.parse(transaction['transaction amount']);

        switch (category) {
          case 'Shopping':
            shoppingAmount += amount;
            break;
          case 'Electronic':
            electronicAmount += amount;
            break;
          case 'Transportation':
            transportationAmount += amount;
            break;
          case 'FoodandBeverage':
            foodandbeverageAmount += amount;
            break;
          case 'OtherExpenses':
            otherexpensesAmount += amount;
            break;
          // Handle additional categories if needed
        }
      }

      // Calculate total amount
      double totalAmount = shoppingAmount +
          electronicAmount +
          transportationAmount +
          foodandbeverageAmount +
          otherexpensesAmount; // Add other categories if needed

      // Calculate percentages based on total amount
      double shoppingPercent = (shoppingAmount / totalAmount) * 100;
      double electronicPercent = (electronicAmount / totalAmount) * 100;
      double transportationPercent = (transportationAmount / totalAmount) * 100;
      double foodandbeveragePercent =
          (foodandbeverageAmount / totalAmount) * 100;
      double otherexpensesPercent = (otherexpensesAmount / totalAmount) * 100;

      int shoppingpercentInt = shoppingPercent.toInt();
      int electronicpercentInt = electronicPercent.toInt();
      int transportationpercentInt = transportationPercent.toInt();
      int foodAndBeveragepercentInt = foodandbeveragePercent.toInt();
      int otherExpensespercentInt = otherexpensesPercent.toInt();

      // Update pie chart data in Firestore
      await pieChartDataRef.doc(useremail).update({
        'Shopping percent': shoppingpercentInt,
        'Shopping title': shoppingpercentInt.toString(),
        'Electronic percent': electronicpercentInt,
        'Electronic title': electronicpercentInt.toString(),
        'Transportation percent': transportationpercentInt,
        'Transportation title': transportationpercentInt.toString(),
        'FoodandBeverage percent': foodAndBeveragepercentInt,
        'FoodandBeverage title': foodAndBeveragepercentInt.toString(),
        'OtherExpenses percent': otherExpensespercentInt,
        'OtherExpenses title': otherExpensespercentInt.toString(),
      });
    } catch (error) {
      print('Error updating pie chart data: $error');
    }
  }

  Future<double> getTotalExpense() async {
    double totalExpense = 0;

    try {
      QuerySnapshot expensesSnapshot =
          await FirebaseFirestore.instance.collection('transactions').get();

      for (QueryDocumentSnapshot expense in expensesSnapshot.docs) {
        // Assuming there's a field named 'transaction amount' in each expense document
        totalExpense += double.parse(expense['transaction amount']);
      }
    } catch (error) {
      print('Error fetching total expense: $error');
    }

    return totalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final useremail = user?.email;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 790,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9489F5), Color(0xFF6D5FED)],
                stops: [0, 1],
                begin: AlignmentDirectional(0, -1),
                end: AlignmentDirectional(0, 1),
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 180, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Container(
                      width: double.infinity,
                      height: 390,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'State Your Transaction',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 29.0,
                                    color: Color(0xFF101213)),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 24),
                                child: Text(
                                  'State your transaction by filling out the form below.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Color(0xFF57636C)),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                child: Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF1F4F8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Color(0xFFE0E3E7), width: 2)),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        11, 0, 0, 0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        elevation: 8,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                            color: Color(0xFF101213)),
                                        value: dropdownValue,
                                        onChanged: (String? newValue) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Shopping',
                                          'Electronic',
                                          'Transportation',
                                          'FoodandBeverage',
                                          'OtherExpenses'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        icon: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Color(0xFF57636C),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: transactionAmountController,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Transaction Amount',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: Color(0xFF57636C)),
                                      alignLabelWithHint: false,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          color: Color(0xFF57636C)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF9489F5),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE0E3E7),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE74852),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF1F4F8),
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                        color: Color(0xFF101213)),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 16, 0, 16),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1,
                                      )),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Color(0xFF6D5FED);
                                        }
                                        return Color(0xFF9489F5);
                                      }),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      String selectedDropdownValue =
                                          dropdownValue;
                                      double transactionAmount = double.parse(
                                          transactionAmountController.text);

                                      saveDataToFirestore(selectedDropdownValue,
                                          transactionAmount);
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
