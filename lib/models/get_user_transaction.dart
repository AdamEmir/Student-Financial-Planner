import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetUserTransaction extends StatelessWidget {
  final String documentId;

  GetUserTransaction({required this.documentId});

  String formatTransactionDate(Timestamp timestamp) {
    // Convert the timestamp to a DateTime object
    final DateTime dateTime = timestamp.toDate();

    // Format the DateTime object using the desired format
    final DateFormat formatter = DateFormat('MMM. dd, HH:mm');

    // Return the formatted date string
    return formatter.format(dateTime);
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Electronic':
        return Icons.laptop_rounded;
      case 'Transportation':
        return Icons.train_rounded;
      case 'FoodandBeverage':
        return Icons.fastfood_rounded;
      case 'OtherExpenses':
        return Icons.receipt_rounded;
      default:
        // You can set a default icon here if the category doesn't match any of the above
        return Icons.monetization_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');

    return FutureBuilder<DocumentSnapshot>(
      future: transactions.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
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
                  color: Color(0xFFFFFFFF),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFF4D9489F5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Icon(
                            _getIconForCategory(data['transaction category']),
                            color: Color(0xFF9489F5),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                '${data['transaction type']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0,
                                    color: data['transaction type'] == 'Expense'
                                        ? Color(0xFFE74852)
                                        : Color(0xFF24A891)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
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
                                color: data['transaction type'] == 'Expense'
                                    ? Color(0xFFE74852)
                                    : Color(0xFF24A891)),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
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
          );
        }
        return Text("No transaction history");
      }),
    );
  }
}
