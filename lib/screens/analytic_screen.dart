import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get the collection reference
  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');

  double totalExpense = 0.00;

  //Shopping calculation variables to get shopping indicator percentage
  double totalShopping = 0.00;
  double shoppingPercent = 0.00;
  double calculateShoppingPercent = 0.00;
  String shoppingTextPercent = '';

  //Electronic calculation variables to get electronic indicator percentage
  double totalElectronic = 0.00;
  double electronicPercent = 0.00;
  double calculateElectronicPercent = 0.00;
  String electronicTextPercent = '';

  //Transportation calculation variables to get transportation indicator percentage
  double totalTransportation = 0.00;
  double transportationPercent = 0.00;
  double calculateTransportationPercent = 0.00;
  String transportationTextPercent = '';

  //FoodandBeverage calculation variables to get foodandbeverage indicator percentage
  double totalFnb = 0.00;
  double fnbPercent = 0.00;
  double calculateFnbPercent = 0.00;
  String fnbTextPercent = '';

  //OtherExpenses calculation variables to get otherexpenses indicator percentage
  double totalOtherExpenses = 0.00;
  double otherexpensesPercent = 0.00;
  double calculateOtherExpensesPercent = 0.00;
  String otherexpensesTextPercent = '';

  void fetchExpenseData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    QuerySnapshot snapshot =
        await transactionsRef.where('email', isEqualTo: useremail).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      // Assuming your Firestore document structure has 'type' and 'amount' fields
      String transactionType = doc['transaction type'];
      String transactionCategory = doc['transaction category'];
      String transactionAmount = doc['transaction amount'];

      double calculationtransactionAmount = double.parse(transactionAmount);

      if (transactionType == 'Expense') {
        totalExpense += calculationtransactionAmount;
        if (transactionCategory == 'Shopping') {
          totalShopping += calculationtransactionAmount;
        } else if (transactionCategory == 'Electronic') {
          totalElectronic += calculationtransactionAmount;
        } else if (transactionCategory == 'Transportation') {
          totalTransportation += calculationtransactionAmount;
        } else if (transactionCategory == 'FoodandBeverage') {
          totalFnb += calculationtransactionAmount;
        } else if (transactionCategory == 'OtherExpenses') {
          totalOtherExpenses += calculationtransactionAmount;
        }
      }
    }
    // Calculate shopping percentage
    calculateShoppingPercent = (totalShopping * 1) / totalExpense;
    // Convert shopping percentage to 2 decimals points
    String formattedShoppingPercent =
        calculateShoppingPercent.toStringAsFixed(2);
    shoppingPercent = (double.parse(formattedShoppingPercent));
    // Convert shopping percentage to String
    shoppingTextPercent = (calculateShoppingPercent * 100).toStringAsFixed(0);

    // Calculate electronic percentage
    calculateElectronicPercent = (totalElectronic * 1) / totalExpense;
    // Convert electronic percentage to 2 decimals points
    String formattedElectronicPercent =
        calculateElectronicPercent.toStringAsFixed(2);
    electronicPercent = (double.parse(formattedElectronicPercent));
    // Convert electronic percentage to String
    electronicTextPercent =
        (calculateElectronicPercent * 100).toStringAsFixed(0);

    // Calculate transportation percentage
    calculateTransportationPercent = (totalTransportation * 1) / totalExpense;
    // Convert transportation percentage to 2 decimals points
    String formattedTransportationPercent =
        calculateTransportationPercent.toStringAsFixed(2);
    transportationPercent = (double.parse(formattedTransportationPercent));
    // Convert transportation percentage to String
    transportationTextPercent =
        (calculateTransportationPercent * 100).toStringAsFixed(0);

    // Calculate foodandbeverage percentage
    calculateFnbPercent = (totalFnb * 1) / totalExpense;
    // Convert foodandbeverage percentage to 2 decimals points
    String formattedFnbPercent = calculateFnbPercent.toStringAsFixed(2);
    fnbPercent = (double.parse(formattedFnbPercent));
    // Convert foodandbeverage percentage to String
    fnbTextPercent = (calculateFnbPercent * 100).toStringAsFixed(0);

    // Calculate shopping percentage
    calculateOtherExpensesPercent = (totalOtherExpenses * 1) / totalExpense;
    // Convert shopping percentage to 2 decimals points
    String formattedOtherExpensesPercent =
        calculateOtherExpensesPercent.toStringAsFixed(2);
    otherexpensesPercent = (double.parse(formattedOtherExpensesPercent));
    // Convert shopping percentage to String
    otherexpensesTextPercent =
        (calculateOtherExpensesPercent * 100).toStringAsFixed(0);

    // Update the state to trigger a redraw of the chart
    setState(() {});
  }

  Color getProgressColor(double shoppingPercent) {
    if (shoppingPercent < 0.5) {
      return Color(0xFF24A891);
    } else if (shoppingPercent >= 0.5 && shoppingPercent <= 0.75) {
      return Color(0xffFF6D33);
    } else {
      return Color(0xFFE74852);
    }
  }

  CollectionReference transactiondata =
      FirebaseFirestore.instance.collection('transactions');
  double totalLineChartExpense = 0.00;
  double expenseJanuary = 0.00;
  double expenseFebruary = 0.00;
  double expenseMarch = 0.00;
  double expenseApril = 0.00;
  double expenseMay = 0.00;
  double expenseJune = 0.00;
  double expenseJuly = 0.00;
  double expenseAugust = 0.00;
  double expenseSeptember = 0.00;
  double expenseOctober = 0.00;
  double expenseNovember = 0.00;
  double expenseDecember = 0.00;
  String formattedexpenseNovember = '';

  void fetchLineChartData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    QuerySnapshot snapshot =
        await transactiondata.where('email', isEqualTo: useremail).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      try {
        // Assuming your Firestore document structure has 'type' and 'amount' fields
        String transactionType = doc['transaction type'];
        String transactionAmount = doc['transaction amount'];
        Timestamp timestamp = doc['transaction date'];
        double calculationtransactionAmount = double.parse(transactionAmount);
        // Convert Timestamp to DateTime
        DateTime dateTime = timestamp.toDate();
        // Extract the month from the DateTime
        String month = DateFormat('MMMM').format(dateTime);

        if (transactionType == 'Expense') {
          totalLineChartExpense += calculationtransactionAmount;
          if (month == 'January') {
            expenseJanuary += calculationtransactionAmount;
          } else if (month == 'February') {
            expenseFebruary += calculationtransactionAmount;
          } else if (month == 'March') {
            expenseMarch += calculationtransactionAmount;
          } else if (month == 'April') {
            expenseApril += calculationtransactionAmount;
          } else if (month == 'May') {
            expenseMay += calculationtransactionAmount;
          } else if (month == 'June') {
            expenseJune += calculationtransactionAmount;
          } else if (month == 'July') {
            expenseJuly += calculationtransactionAmount;
          } else if (month == 'August') {
            expenseAugust += calculationtransactionAmount;
          } else if (month == 'September') {
            expenseSeptember += calculationtransactionAmount;
          } else if (month == 'October') {
            expenseOctober += calculationtransactionAmount;
          } else if (month == 'November') {
            expenseNovember += calculationtransactionAmount;
          } else if (month == 'December') {
            expenseDecember += calculationtransactionAmount;
          }
        }
      } catch (error) {
        print('Make Expense Transaction to Generate Chart');
      }
    }

    setState(() {});
  }

  List<Color> gradientColors = [
    Color(0xffffffff),
    Color(0xFF9489F5),
    Color(0xff9B3192),
  ];

  @override
  void initState() {
    super.initState();
    fetchExpenseData();
    fetchLineChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF6D5FED),
      ),
      body: // Generated code for this Container Widget...
          Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
          fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 191, 186, 245),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text(
                        'Analytics',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 28.0,
                            color: Color(0xffffffff)),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                AspectRatio(
                                  aspectRatio: 1.70,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 18,
                                      left: 12,
                                      top: 24,
                                      bottom: 12,
                                    ),
                                    child: LineChart(
                                      mainData(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Your Spending Status',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.92,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x35000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFF1F4F8),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 0, 0),
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        color: Color(0xFF4D9489F5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 8, 8, 8),
                                          child: Icon(
                                            Icons.shopping_bag,
                                            color: Color(0xFF9489F5),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Shopping',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                  color: Color(0xFF101213)),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 10, 0, 0),
                                              child: LinearPercentIndicator(
                                                percent: shoppingPercent,
                                                lineHeight: 26,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor: getProgressColor(
                                                    shoppingPercent),
                                                backgroundColor:
                                                    Color(0xFFCCFFFFFF),
                                                center: Text(
                                                  '$shoppingTextPercent%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0,
                                                    color: Color(0xFF101213),
                                                  ),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 16, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.92,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x35000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFF1F4F8),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 0, 0),
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        color: Color(0xFF4D9489F5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 8, 8, 8),
                                          child: Icon(
                                            Icons.devices,
                                            color: Color(0xFF9489F5),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Electronics',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                  color: Color(0xFF101213)),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 10, 0, 0),
                                              child: LinearPercentIndicator(
                                                percent: electronicPercent,
                                                lineHeight: 26,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor: getProgressColor(
                                                    electronicPercent),
                                                backgroundColor:
                                                    Color(0xFFCCFFFFFF),
                                                center: Text(
                                                  '$electronicTextPercent%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0,
                                                    color: Color(0xFF101213),
                                                  ),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 16, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.92,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x35000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFF1F4F8),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 0, 0),
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        color: Color(0xFF4D9489F5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 8, 8, 8),
                                          child: Icon(
                                            Icons.directions_car,
                                            color: Color(0xFF9489F5),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Transportation',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                  color: Color(0xFF101213)),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 10, 0, 0),
                                              child: LinearPercentIndicator(
                                                percent: transportationPercent,
                                                lineHeight: 26,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor: getProgressColor(
                                                    transportationPercent),
                                                backgroundColor:
                                                    Color(0xFFCCFFFFFF),
                                                center: Text(
                                                  '$transportationTextPercent%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0,
                                                    color: Color(0xFF101213),
                                                  ),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 16, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.92,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x35000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFF1F4F8),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 0, 0),
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        color: Color(0xFF4D9489F5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 8, 8, 8),
                                          child: Icon(
                                            Icons.fastfood_rounded,
                                            color: Color(0xFF9489F5),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Food & Beverage',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                  color: Color(0xFF101213)),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 10, 0, 0),
                                              child: LinearPercentIndicator(
                                                percent: fnbPercent,
                                                lineHeight: 26,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor: getProgressColor(
                                                    fnbPercent),
                                                backgroundColor:
                                                    Color(0xFFCCFFFFFF),
                                                center: Text(
                                                  '$fnbTextPercent%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0,
                                                    color: Color(0xFF101213),
                                                  ),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 16, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.92,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x35000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFF1F4F8),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 0, 0),
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        color: Color(0xFF4D9489F5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 8, 8, 8),
                                          child: Icon(
                                            Icons.receipt_rounded,
                                            color: Color(0xFF9489F5),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Other Expenses',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                  color: Color(0xFF101213)),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 10, 0, 0),
                                              child: LinearPercentIndicator(
                                                percent: otherexpensesPercent,
                                                lineHeight: 26,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor: getProgressColor(
                                                    otherexpensesPercent),
                                                backgroundColor:
                                                    Color(0xFFCCFFFFFF),
                                                center: Text(
                                                  '$otherexpensesTextPercent%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0,
                                                    color: Color(0xFF101213),
                                                  ),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 16, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xffffffff));
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('JAN', style: style);
        break;
      case 1:
        text = const Text('FEB', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 3:
        text = const Text('APR', style: style);
        break;
      case 4:
        text = const Text('MAY', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 6:
        text = const Text('JULY', style: style);
        break;
      case 7:
        text = const Text('AUG', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      case 9:
        text = const Text('OCT', style: style);
        break;
      case 10:
        text = const Text('NOV', style: style);
        break;
      case 11:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'Expenses';
        break;

      default:
        return Container();
    }

    return Transform.rotate(
      angle: -1.5708, // 90 degrees in radians
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xffE74852),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xffE74852),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text(
            'Expenses (RM)',
            style: TextStyle(
              color: Color(0xffffffff),
            ),
          ),
          axisNameSize: 24,
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 0,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(width: 4, color: const Color(0xff6D5FED)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: totalLineChartExpense,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, expenseJanuary), //jan
            FlSpot(1, expenseFebruary), //feb
            FlSpot(2, expenseMarch), //march
            FlSpot(3, expenseApril), //april
            FlSpot(4, expenseMay), //may
            FlSpot(5, expenseJune), //june
            FlSpot(6, expenseJuly), //juy
            FlSpot(7, expenseAugust), //aug
            FlSpot(8, expenseSeptember), //sep
            FlSpot(9, expenseOctober), //oct
            FlSpot(10, expenseNovember), //nov
            FlSpot(11, expenseDecember), //dec
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
