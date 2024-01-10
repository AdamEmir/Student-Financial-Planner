import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/screens/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListOtherExpensesScreen extends StatefulWidget {
  const ListOtherExpensesScreen({super.key});

  @override
  State<ListOtherExpensesScreen> createState() =>
      _ListOtherExpensesScreenState();
}

class _ListOtherExpensesScreenState extends State<ListOtherExpensesScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference transactiondata =
      FirebaseFirestore.instance.collection('transactions');

  String formatTransactionDate(Timestamp timestamp) {
    // Convert the timestamp to a DateTime object
    final DateTime dateTime = timestamp.toDate();

    // Format the DateTime object using the desired format
    final DateFormat formatter = DateFormat('MMM. dd, HH:mm');

    // Return the formatted date string
    return formatter.format(dateTime);
  }

  void navigateToDetailsScreen(DocumentSnapshot transactionData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailsScreen(transactionData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Expenses'),
        backgroundColor: Color(0xFF6D5FED),
      ),
      body: Container(
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
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: transactiondata
                    .where('email', isEqualTo: auth.currentUser?.email)
                    .where('transaction category', isEqualTo: 'OtherExpenses')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // or a loading indicator
                  }

                  // If we reach here, we have data
                  var transactions = snapshot.data!.docs;

                  // Build the list of transactions
                  List<Widget> transactionWidgets = transactions.map((data) {
                    // Use your existing code for building a transaction widget
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the details screen
                        navigateToDetailsScreen(data);
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
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
                            padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: Color(0xFFFFFFFF),
                                    shadowColor: Color(0xff2b0b3f),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 8, 8, 8),
                                      child: Icon(
                                        Icons.receipt_rounded,
                                        color: Color(0xff2b0b3f),
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
                                          '${data['transaction category']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0,
                                              color: Color(0xFF101213)),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 0, 0),
                                          child: Text(
                                            '${data['transaction type']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.0,
                                                color: Color(0xFFE74852)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 12, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'RM' + '${data['transaction amount']}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.0,
                                            color: Color(0xFFE74852)),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                        child: Text(
                                          '${formatTransactionDate(data['transaction date'])}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0,
                                              color: Color(0xFF57636C)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList();

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: transactionWidgets,
                  );
                },
              ),
              Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: Color(0x00FFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
