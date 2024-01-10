import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/models/get_user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //document IDs
  List<String> docIDs = [];

  //get docIDs
  Future getDocId() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;
    await FirebaseFirestore.instance
        .collection('transactions')
        .where('email', isEqualTo: useremail)
        .orderBy('transaction date created', descending: true)
        .limit(10)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  //get the collection
  CollectionReference piechartdata =
      FirebaseFirestore.instance.collection('piechartdata');

  CollectionReference transactiondata =
      FirebaseFirestore.instance.collection('transactions');

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Electronic':
        return Icons.devices;
      case 'Transportation':
        return Icons.directions_car;
      case 'FoodandBeverage':
        return Icons.fastfood_rounded;
      case 'OtherExpenses':
        return Icons.receipt_rounded;
      default:
        // You can set a default icon here if the category doesn't match any of the above
        return Icons.monetization_on_rounded;
    }
  }

  String formatTransactionDate(Timestamp timestamp) {
    // Convert the timestamp to a DateTime object
    final DateTime dateTime = timestamp.toDate();

    // Format the DateTime object using the desired format
    final DateFormat formatter = DateFormat('MMM. dd, HH:mm');

    // Return the formatted date string
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _updateExpenseData();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final useremail = user?.email;
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
                height: 380,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
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
                        'Expenses',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 28.0,
                            color: Color(0xFF101213)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 42, 16, 12),
                          child: Container(
                            width: 370,
                            height: 230,
                            child: AspectRatio(
                              aspectRatio: 1.3,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 0,
                                    sections: _sections,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                elevation: 10,
                child: Container(
                  width: double.infinity,
                  height: 115,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<Map<String, dynamic>>(
                          future: fetchTransactionTotals(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Widget> typeContainers = [];

                              if ((snapshot.data!['OtherExpenses'] ?? 0.0) >
                                  0) {
                                typeContainers.add(buildTransactionContainer(
                                    'Other expenses',
                                    Icons.receipt_rounded,
                                    snapshot.data!['OtherExpenses'] ?? 0.0,
                                    iconColor: Color(0xff2b0b3f),
                                    shadowColor: Color(0xff2b0b3f),
                                    routeName: '/listotherexpenses'));
                              }

                              if ((snapshot.data!['Shopping'] ?? 0.0) > 0) {
                                typeContainers.add(buildTransactionContainer(
                                    'Shopping',
                                    Icons.shopping_bag,
                                    snapshot.data!['Shopping'] ?? 0.0,
                                    iconColor: Color(0xffF7B7A3),
                                    shadowColor: Color(0xffF7B7A3),
                                    routeName: '/listshopping'));
                              }

                              if ((snapshot.data!['Electronic'] ?? 0.0) > 0) {
                                typeContainers.add(buildTransactionContainer(
                                    'Electronic',
                                    Icons.devices,
                                    snapshot.data!['Electronic'] ?? 0.0,
                                    iconColor: Color(0xffEA5F89),
                                    shadowColor: Color(0xffEA5F89),
                                    routeName: '/listelectronic'));
                              }

                              if ((snapshot.data!['Transportation'] ?? 0.0) >
                                  0) {
                                typeContainers.add(buildTransactionContainer(
                                    'Transportation',
                                    Icons.directions_car,
                                    snapshot.data!['Transportation'] ?? 0.0,
                                    iconColor: Color(0xff9B3192),
                                    shadowColor: Color(0xff9B3192),
                                    routeName: '/listtransportation'));
                              }

                              if ((snapshot.data!['FoodandBeverage'] ?? 0.0) >
                                  0) {
                                typeContainers.add(buildTransactionContainer(
                                    'Food & Beverage',
                                    Icons.fastfood,
                                    snapshot.data!['FoodandBeverage'] ?? 0.0,
                                    iconColor: Color(0xff57167E),
                                    shadowColor: Color(0xff57167E),
                                    routeName: '/listfoodandbeverage'));
                              }

                              return Row(
                                children: typeContainers,
                              );
                            } else {
                              // Return an empty container or placeholder
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Transactions History',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: transactiondata
                                .where('email',
                                    isEqualTo: auth.currentUser?.email)
                                .orderBy('transaction date created',
                                    descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // or a loading indicator
                              }

                              // If we reach here, we have data
                              var transactions = snapshot.data!.docs;

                              // Build the list of transactions
                              List<Widget> transactionWidgets =
                                  transactions.take(10).map((data) {
                                // Use your existing code for building a transaction widget
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 12),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.92,
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
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4, 4, 4, 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8, 0, 0, 0),
                                            child: Card(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              color: Color(0xFFFFFFFF),
                                              shadowColor: Color(0xFF9489F5),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(8, 8, 8, 8),
                                                child: Icon(
                                                  _getIconForCategory(data[
                                                      'transaction category']),
                                                  color: Color(0xFF9489F5),
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 0, 0, 0),
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.0,
                                                        color:
                                                            Color(0xFF101213)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      '${data['transaction type']}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11.0,
                                                          color: data['transaction type'] ==
                                                                  'Expense'
                                                              ? Color(
                                                                  0xFFE74852)
                                                              : Color(
                                                                  0xFF24A891)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 0, 12, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'RM' +
                                                      '${data['transaction amount']}',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 22.0,
                                                      color: data['transaction type'] ==
                                                              'Expense'
                                                          ? Color(0xFFE74852)
                                                          : Color(0xFF24A891)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 0),
                                                  child: Text(
                                                    '${formatTransactionDate(data['transaction date'])}',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.0,
                                                        color:
                                                            Color(0xFF57636C)),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchTransactionTotals() async {
    try {
      // Query Firestore to get totals for each transaction type
      Map<String, dynamic> totalsMap = {};

      List<String> transactionTypes = [
        'OtherExpenses',
        'Shopping',
        'Electronic',
        'Transportation',
        'FoodandBeverage',
      ];

      for (String type in transactionTypes) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await transactiondata
                .where('email', isEqualTo: auth.currentUser?.email)
                .where('transaction category', isEqualTo: type)
                .get() as QuerySnapshot<Map<String, dynamic>>;

        double total = 0.0;
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
          // Convert the transaction amount from string to double
          double amount =
              double.tryParse(document['transaction amount'] ?? '0.0') ?? 0.0;
          total += amount;
        }

        totalsMap[type] = total;
      }

      return totalsMap;
    } catch (e) {
      // Handle exceptions here
      print('Error fetching transaction totals: $e');
      // You may want to return an empty map or a default value in case of an error
      return {};
    }
  }

  Widget buildTransactionContainer(String title, IconData icon, double amount,
      {required Color iconColor,
      required Color shadowColor,
      required String routeName}) {
    return GestureDetector(
      onTap: () {
        // Navigate to the specified route
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: 110,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        alignment: AlignmentDirectional(0.00, 0.00),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFFFFFFF),
                elevation: 4,
                shadowColor: shadowColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 7, 0, 2),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                    color: Color(0xFF101213),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Text(
                  'RM ${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.0,
                    color: Color(0xFFE74852),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateExpenseData() async {
    try {
      List<PieChartSectionData> sections = await fetchExpenseData();

      // Check if the sections list is not empty before updating the state
      if (sections.isNotEmpty) {
        setState(() {
          _sections = sections;
        });
      }
    } catch (e) {
      // Handle exceptions here
      print('Error updating expense data: $e');
      // You may want to show an error message to the user or log the error
    }
  }

  Future<List<PieChartSectionData>> fetchExpenseData() async {
    try {
      final User? user = auth.currentUser;
      final useremail = user?.email;

      QuerySnapshot snapshot =
          await transactiondata.where('email', isEqualTo: useremail).get();
      // Check if the snapshot is empty
      if (snapshot.docs.isEmpty) {
        print('No data found in the database.');
        return [];
      }

      double totalExpense = 0.00;
      double totalShopping = 0.00;
      double totalElectronic = 0.00;
      double totalTransportation = 0.00;
      double totalFnb = 0.00;
      double totalOtherExpenses = 0.00;

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        String transactionType = doc['transaction type'];
        String transactionCategory = doc['transaction category'];
        String transactionAmount = doc['transaction amount'];

        double calculationtransactionAmount =
            double.parse(transactionAmount) ?? 0.0;

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

      // Check if totalExpense is zero to avoid division by zero
      if (totalExpense == 0) {
        print('Total expense is zero, cannot calculate percentages.');
        return [];
      }

      double calculateShoppingPercent = (totalShopping * 1) / totalExpense;
      String shoppingTextPercent =
          (calculateShoppingPercent * 100).toStringAsFixed(0);

      double calculateElectronicPercent = (totalElectronic * 1) / totalExpense;
      String electronicTextPercent =
          (calculateElectronicPercent * 100).toStringAsFixed(0);

      double calculateTransportationPercent =
          (totalTransportation * 1) / totalExpense;
      String transportationTextPercent =
          (calculateTransportationPercent * 100).toStringAsFixed(0);

      double calculateFnbPercent = (totalFnb * 1) / totalExpense;
      String fnbTextPercent = (calculateFnbPercent * 100).toStringAsFixed(0);

      double calculateOtherExpensesPercent =
          (totalOtherExpenses * 1) / totalExpense;
      String otherexpensesTextPercent =
          (calculateOtherExpensesPercent * 100).toStringAsFixed(0);

      return showingSections(
        calculateShoppingPercent,
        shoppingTextPercent,
        calculateElectronicPercent,
        electronicTextPercent,
        calculateTransportationPercent,
        transportationTextPercent,
        calculateFnbPercent,
        fnbTextPercent,
        calculateOtherExpensesPercent,
        otherexpensesTextPercent,
      );
    } catch (e) {
      // Handle exceptions here
      print('Error fetching expense data: $e');
      // You may want to return an empty list or a default value in case of an error
      return [];
    }
  }

  List<PieChartSectionData> showingSections(
    double shoppingPercent,
    String shoppingTextPercent,
    double electronicPercent,
    String electronicTextPercent,
    double transportationPercent,
    String transportationTextPercent,
    double fnbPercent,
    String fnbTextPercent,
    double otherexpensesPercent,
    String otherexpensesTextPercent,
  ) {
    return List.generate(5, (i) {
      final fontSize = 16.0;
      final radius = 125.0;
      final widgetSize = 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xffF7B7A3),
            value: shoppingPercent,
            title: shoppingTextPercent + "%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Container(
              width: widgetSize + 8.0,
              height: widgetSize + 8.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.0),
                  color: Colors.white),
              child: Icon(
                Icons.shopping_bag,
                size: widgetSize - 8,
                color: Color(0xffF7B7A3),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xffEA5F89),
            value: electronicPercent,
            title: electronicTextPercent + "%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Container(
              width: widgetSize + 8.0,
              height: widgetSize + 8.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.0),
                  color: Colors.white),
              child: Icon(
                Icons.devices,
                size: widgetSize - 8,
                color: Color(0xffEA5F89),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xff9B3192),
            value: transportationPercent,
            title: transportationTextPercent + "%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Container(
              width: widgetSize + 8.0,
              height: widgetSize + 8.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.0),
                  color: Colors.white),
              child: Icon(
                Icons.directions_car,
                size: widgetSize - 8,
                color: Color(0xff9B3192),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Color(0xff57167E),
            value: fnbPercent,
            title: fnbTextPercent + "%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Container(
              width: widgetSize + 8.0,
              height: widgetSize + 8.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.0),
                  color: Colors.white),
              child: Icon(
                Icons.fastfood_rounded,
                size: widgetSize - 8,
                color: Color(0xff57167E),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: Color(0xff2b0b3f),
            value: otherexpensesPercent,
            title: otherexpensesTextPercent + "%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Container(
              width: widgetSize + 8.0,
              height: widgetSize + 8.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.0),
                  color: Colors.white),
              child: Icon(
                Icons.receipt_rounded,
                size: widgetSize - 8,
                color: Color(0xff2b0b3f),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }

  List<PieChartSectionData> _sections = [];
}
