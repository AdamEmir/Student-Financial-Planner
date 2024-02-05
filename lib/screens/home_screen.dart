import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:emojis/emojis.dart';
import 'package:intl/intl.dart';

import 'package:firstly/screens/combine_screen.dart';
import 'package:firstly/screens/edit_transaction_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //document IDs
  List<String> docIDs = [];
  bool docIdFetched = false; // Add a flag to track if docIds have been fetched
  // Add a Future to store the result of getDocId
  late Future<void> docIdFuture;
  //get docIDs
  Future getDocId() async {
    if (docIdFetched) {
      return; // If already fetched, don't fetch again
    }

    final User? user = auth.currentUser;
    final useremail = user?.email;
    await FirebaseFirestore.instance
        .collection('transactions')
        .where('email', isEqualTo: useremail)
        .orderBy('transaction date created', descending: true)
        .limit(3)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );

    docIdFetched = true; // Set the flag to true after fetching
  }

  //BarChart Components Begins Here

  bool dataLoaded = false; // Add a flag to track data loading

  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');
  CollectionReference savingsRef =
      FirebaseFirestore.instance.collection('savings');
  CollectionReference barchartMaxRef =
      FirebaseFirestore.instance.collection('userbarchartmax');
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');
  double totalIncome = 0.00;
  double totalExpense = 0.00;
  double parsebarchartMax = 0.00;
  double totalIncomeDeduction = 0.00;
  double savingsNumbers = 0.00;
  double savingsUserTotalIncome = 0.00;
  String userfullname = '';

  void fetchBarchartData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    QuerySnapshot snapshot =
        await transactionsRef.where('email', isEqualTo: useremail).get();

    QuerySnapshot savingsnapshot =
        await savingsRef.where('email', isEqualTo: useremail).get();

    QuerySnapshot savingsUserTotalIncomesnapshot =
        await barchartMaxRef.where('email', isEqualTo: useremail).get();

    QuerySnapshot usersnapshot =
        await userRef.where('email', isEqualTo: useremail).get();

    for (QueryDocumentSnapshot doc in usersnapshot.docs) {
      // Assuming your Firestore document structure has 'type' and 'amount' fields
      String userfullnamedb = doc['fullName'];

      userfullname = userfullnamedb;
    }

    for (QueryDocumentSnapshot doc in savingsUserTotalIncomesnapshot.docs) {
      // Assuming your Firestore document structure has 'type' and 'amount' fields

      String barchartMax = doc['barchartmax'];
      savingsUserTotalIncome = double.parse(barchartMax);
    }

    for (QueryDocumentSnapshot doc in savingsnapshot.docs) {
      // Assuming your Firestore document structure has 'type' and 'amount' fields
      String savingsPercentage = doc['savings percentage'];

      if (savingsPercentage == '0%') {
        savingsNumbers;
      } else if (savingsPercentage == '5%') {
        savingsNumbers = (5 * savingsUserTotalIncome) / 100;
      } else if (savingsPercentage == '10%') {
        savingsNumbers = (10 * savingsUserTotalIncome) / 100;
      } else if (savingsPercentage == '15%') {
        savingsNumbers = (15 * savingsUserTotalIncome) / 100;
      } else if (savingsPercentage == '20%') {
        savingsNumbers = (20 * savingsUserTotalIncome) / 100;
      } else if (savingsPercentage == '25%') {
        savingsNumbers = (25 * savingsUserTotalIncome) / 100;
      }
    }

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      // Assuming your Firestore document structure has 'type' and 'amount' fields
      String transactionType = doc['transaction type'];
      String transactionAmount = doc['transaction amount'];
      double calculationtransactionAmount = double.parse(transactionAmount);

      if (transactionType == 'Income') {
        totalIncome += calculationtransactionAmount;
      } else if (transactionType == 'Expense') {
        totalExpense += calculationtransactionAmount;
      }
    }

    totalIncomeDeduction = totalIncome - totalExpense;

    // Update the state to trigger a redraw of the chart
    setState(() {});
  }

  void fetchBarchartMax() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    QuerySnapshot snapshot =
        await barchartMaxRef.where('email', isEqualTo: useremail).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      // Assuming your Firestore document structure has 'type' and 'amount' fields

      String barchartMax = doc['barchartmax'];
      parsebarchartMax = double.parse(barchartMax);
    }

    // Update the state to trigger a redraw of the chart
    setState(() {});
  }

  //Barchart Components End Here

  Color getIconButtonColor() {
    double income = totalIncomeDeduction;
    double expense = totalExpense;
    double savings = savingsNumbers;
    if (income > expense) {
      return Color(0xFF39D2C0);
    } else if (income <= expense && income > savings) {
      return Color(0xffFFD300);
    } else if (income <= savings && income < expense) {
      return Color(0xFFE74852);
    } else {
      return Color(
          0xFF9489F5); // Default color, or change it to the desired color
    }
  }

  String getTextStatus() {
    String textStatus = "";
    double income = totalIncomeDeduction;
    double expense = totalExpense;
    double savings = savingsNumbers;
    if (income > expense) {
      return textStatus =
          "Your Financial Health is Healthy ${Emojis.flexedBicepsLightSkinTone}";
    } else if (income <= expense && income > savings) {
      return textStatus =
          "Your Financial Health is Not Good ${Emojis.grimacingFace}";
    } else if (income <= savings && income < expense) {
      return textStatus =
          "Your Financial Health is at a Critical ${Emojis.fearfulFace}";
    } else {
      return textStatus =
          "Please Insert Income to Set Up Your Account"; // Default color, or change it to the desired color
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

  void navigateToDetailsScreen(DocumentSnapshot transactionData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionDetailScreen(transactionData),
      ),
    );
  }

  @override
  void initState() {
    docIdFuture = getDocId(); // Call getDocId and store the future
    fetchBarchartData();
    fetchBarchartMax();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final CollectionReference _user =
        FirebaseFirestore.instance.collection('Users');
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final userRef = FirebaseFirestore.instance.collection('Users');
    final query = userRef.where('email', isEqualTo: useremail);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              Container(
                width: double.infinity,
                height: 345,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Column(
                  //mother column
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 32, 16, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 4),
                                    child: Text(
                                      'Welcome',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 28.0),
                                    ),
                                  ),
                                  Text(
                                    ' $userfullname',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.notifications_rounded,
                                color: getIconButtonColor(),
                                size: 30,
                              ),
                            ),
                            onPressed: () {
                              double income = totalIncomeDeduction;
                              double expense = totalExpense;
                              double savings = savingsNumbers;
                              if (income > expense) {
                                // Good message with green color
                                Fluttertoast.showToast(
                                  msg: "Spending Behavior Excellent",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                );
                              } else if (income <= expense &&
                                  income > savings) {
                                // Not good message with orange color
                                Fluttertoast.showToast(
                                  msg: "Spending Behavior Average",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                );
                              } else if (income <= savings &&
                                  income < expense) {
                                // Bad message with red color
                                Fluttertoast.showToast(
                                  msg: "Spending Behavior At Critial",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                );
                              } else {
                                // Handle other cases or display a default message
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 42, 16, 12),
                          width: 370,
                          height: 210,
                          child: BarChart(
                            BarChartData(
                              barTouchData: barTouchData,
                              titlesData: titlesData,
                              borderData: borderData,
                              barGroups: barGroups,
                              gridData: const FlGridData(show: false),
                              alignment: BarChartAlignment.spaceAround,
                              maxY: parsebarchartMax,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      '${getTextStatus()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: getIconButtonColor()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 14, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Recent Transactions (Editable)',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: transactionsRef
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
                                  transactions.take(3).map((data) {
                                // Use your existing code for building a transaction widget
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to the details screen
                                    navigateToDetailsScreen(data);
                                  },
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 12),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.92,
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8, 0, 0, 0),
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
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
                                                          color: Color(
                                                              0xFF101213)),
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 0, 12, 0),
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
                                                        color:
                                                            data['transaction type'] ==
                                                                    'Expense'
                                                                ? Color(
                                                                    0xFFE74852)
                                                                : Color(
                                                                    0xFF24A891)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      '${formatTransactionDate(data['transaction date'])}',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0,
                                                          color: Color(
                                                              0xFF57636C)),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CombineScreen()));
        },
        backgroundColor: Color(0xFF39D2C0),
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 24,
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            String tooltipText = 'RM ' + rod.toY.toStringAsFixed(2);
            Color tooltipColor;

            switch (groupIndex) {
              case 0:
                tooltipColor = Color(0xFF6D5FED); // Income
                break;
              case 1:
                tooltipColor = Color(0xFFE74852); // Expense
                break;
              case 2:
                tooltipColor = Color(0xFF24A891); // Saving
                break;
              default:
                tooltipColor = Colors.cyan; // Default color
                break;
            }

            return BarTooltipItem(
              tooltipText,
              TextStyle(
                color: tooltipColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    Color textColor;

    switch (value.toInt()) {
      case 0:
        text = 'Income';
        textColor = Color(0xFF9489F5);
        break;
      case 1:
        text = 'Expense';
        textColor = Color(0xFFFF6D33);
        break;
      case 2:
        text = 'Saving';
        textColor = Color(0xFF39D2C0);
        break;
      default:
        text = '';
        textColor = Colors.black; // Default color
        break;
    }

    final style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              width: 35,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              toY: totalIncomeDeduction,
              gradient: LinearGradient(
                  colors: [Color(0xFF9489F5), Color(0xFF6D5FED)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              width: 35,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              toY: totalExpense.toDouble(),
              gradient: LinearGradient(
                  colors: [Color(0xFFFF6D33), Color(0xFFE74852)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              width: 35,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              toY: savingsNumbers.toDouble(),
              gradient: LinearGradient(
                  colors: [Color(0xFF39D2C0), Color(0xFF24A891)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}
