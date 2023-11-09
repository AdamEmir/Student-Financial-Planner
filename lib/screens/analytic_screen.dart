import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

  @override
  void initState() {
    super.initState();
    fetchExpenseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF9489F5),
      ),
      body: // Generated code for this Container Widget...
          Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9489F5), Color(0xFF6D5FED)],
            stops: [0, 1],
            begin: AlignmentDirectional(0, -1),
            end: AlignmentDirectional(0, 1),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 380,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
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
                        'Analytics Spending',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 28.0,
                            color: Color(0xFF101213)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Line Graph',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Color(0xFF101213)),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: Text(
                            'Line Char Art Here',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: Color(0xFF101213)),
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
                                            Icons.shopping_cart_sharp,
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
                                            Icons.laptop_rounded,
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
                                            Icons.directions_bus_rounded,
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
}
