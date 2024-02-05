import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ExpensesTransactionScreen extends StatefulWidget {
  const ExpensesTransactionScreen({super.key});

  @override
  State<ExpensesTransactionScreen> createState() =>
      _ExpensesTransactionScreenState();
}

class _ExpensesTransactionScreenState extends State<ExpensesTransactionScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final transactionAmountController = TextEditingController();
  final transactionDescriptionController = TextEditingController();
  final transactionDateController = TextEditingController();
  String dropdownValue = 'Shopping';
  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');
  CollectionReference pieChartDataRef =
      FirebaseFirestore.instance.collection('piechartdata');

  void saveDataToFirestore(String dropdownValue, double transactionAmount,
      String transactionDescription, String transactionDate) async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final formattedIncomeAmount = transactionAmount.toStringAsFixed(2);

    // Convert selectedDate to Timestamp
    final timestamp = Timestamp.fromDate(selectedDate);

    if (useremail != null) {
      try {
        await transactionsRef.add({
          'email': useremail,
          'transaction amount': formattedIncomeAmount,
          'transaction category': dropdownValue,
          'transaction type': 'Expense',
          'transaction description': transactionDescription,
          'transaction date': timestamp,
          'transaction date created': Timestamp.now(),
        });

        // Update pie chart data after adding a new transaction
        updatePieChartData();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        Fluttertoast.showToast(
          msg: 'Expense added Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (error) {
        print('Error adding data to Firestore: $error');
        Fluttertoast.showToast(
          msg: 'Expense added Failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  // Method to calculate pie chart data and update Firestore
  Future<void> updatePieChartData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;
    try {
      QuerySnapshot transactionsSnapshot =
          await transactionsRef.where('email', isEqualTo: useremail).get();

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

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Set both date and time parts
      final DateTime selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDate.hour,
        selectedDate.minute,
        selectedDate.second,
      );

      setState(() {
        selectedDate = selectedDateTime;
        transactionDateController.text =
            DateFormat("dd MMMM yyyy , hh:mm:ss a").format(selectedDateTime);
      });
    }
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
                image: DecorationImage(
              image: AssetImage("assets/images/bg2.png"),
              fit: BoxFit.cover,
            )),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Container(
                      width: double.infinity,
                      height: 540,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'State Your Expenses',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 25.0,
                                        color: Color(0xFF101213)),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 24),
                                    child: Text(
                                      'State your expenses by filling out the form below.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          color: Color(0xFF57636C)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 16, 0),
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF1F4F8),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Color(0xFFE0E3E7),
                                              width: 2)),
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: transactionAmountController,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9489F5),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE74852),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: Color(0xFF101213)),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                      ),
                                    ),
                                  ),
                                  //Income Description Start
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller:
                                            transactionDescriptionController,
                                        decoration: InputDecoration(
                                          labelText: 'Description',
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9489F5),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE74852),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: Color(0xFF101213)),
                                      ),
                                    ),
                                  ),
                                  //Income Description Ends
                                  //Income Date Start
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: transactionDateController,
                                        onTap: () => _selectDate(context),
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Date',
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9489F5),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE74852),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: Color(0xFF101213)),
                                      ),
                                    ),
                                  ),
                                  //Income Date Ends
                                  //Submit Button Start
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 1,
                                          )),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                MaterialState.pressed)) {
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
                                          double transactionAmount =
                                              double.parse(
                                                  transactionAmountController
                                                      .text);

                                          String transactionDecription =
                                              transactionDescriptionController
                                                  .text;

                                          String transactionDate =
                                              transactionDateController.text;

                                          saveDataToFirestore(
                                              selectedDropdownValue,
                                              transactionAmount,
                                              transactionDecription,
                                              transactionDate);
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
                              Positioned(
                                left: 13, // Adjust the position as needed
                                top: 77, // Adjust the position as needed
                                child: Text(
                                  'Transaction Type',
                                  style: TextStyle(
                                      color: Color(0xFF57636C),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.0,
                                      backgroundColor: Colors.white),
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
