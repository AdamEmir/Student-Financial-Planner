import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstly/screens/update_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTransactionDetailScreen extends StatefulWidget {
  final DocumentSnapshot transactionData;
  const EditTransactionDetailScreen(this.transactionData, {super.key});

  @override
  State<EditTransactionDetailScreen> createState() =>
      _EditTransactionDetailScreenState();
}

class _EditTransactionDetailScreenState
    extends State<EditTransactionDetailScreen> {
  String formatTransactionDate(Timestamp timestamp) {
    // Convert the timestamp to a DateTime object
    final DateTime dateTime = timestamp.toDate();

    // Format the DateTime object using the desired format
    final DateFormat formatter = DateFormat('MMM. dd, HH:mm');

    // Return the formatted date string
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // Extract data from the transactionData and display details
    // Example:
    var transactionCategory = widget.transactionData['transaction category'];

    var transactionAmount = widget.transactionData['transaction amount'];
    var transactionDate =
        formatTransactionDate(widget.transactionData['transaction date']);
    var transactionDateCreated = formatTransactionDate(
        widget.transactionData['transaction date created']);
    var transactionDesc = widget.transactionData['transaction description'];

    Icon getTransactionCategoryIcon(String category) {
      switch (category) {
        case 'Electronic':
          return Icon(Icons.devices, color: Color(0xffEA5F89), size: 80);
        case 'Shopping':
          return Icon(Icons.shopping_bag, color: Color(0xffF7B7A3), size: 80);
        case 'OtherExpenses':
          return Icon(Icons.receipt_rounded,
              color: Color(0xff2b0b3f), size: 80);
        case 'Transportation':
          return Icon(Icons.directions_car, color: Color(0xff9B3192), size: 80);
        case 'FoodandBeverage':
          return Icon(Icons.fastfood, color: Color(0xff57167E), size: 80);
        default:
          return Icon(Icons.monetization_on_rounded,
              color: Color(0xFF9489F5), size: 80);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
        backgroundColor: Color(0xFF6D5FED),
      ),
      body: SafeArea(
        top: true,
        child: Container(
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
              children: [
                Container(
                  width: double.infinity,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Color(0x00FFFFFF),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(0xFFFFFFFF),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              getTransactionCategoryIcon(transactionCategory),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Text(
                          '$transactionCategory',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                              color: Color(0xFFFFFFFF)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Text(
                          'RM $transactionAmount',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                              color: Color(0xFFE74852)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(81, 0, 0, 0),
                              child: Text(
                                ':',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Text(
                                  '$transactionDesc',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                              child: Text(
                                'Transaction Made',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(34, 0, 0, 0),
                              child: Text(
                                ':',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Text(
                                  '$transactionDate',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                              child: Text(
                                'Transaction Created',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                              child: Text(
                                ':',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Text(
                                  '$transactionDateCreated',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateTransactionScreen(
                                            transactionData:
                                                widget.transactionData)));
                          },
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: Color(0xFFFFFFFF),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.edit_square,
                                color: Color(0xFF6D5FED),
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Edit \nTransaction',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Color(0xFFFFFFFF)),
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
  }
}
