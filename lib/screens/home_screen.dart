import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/models/get_user_transaction.dart';
import 'package:firstly/screens/combine_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
        .orderBy('transaction date', descending: true)
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
  CollectionReference barchartMaxRef =
      FirebaseFirestore.instance.collection('userbarchartmax');
  double totalIncome = 0.00;
  double totalExpense = 0.00;
  double parsebarchartMax = 0.00;

  void fetchBarchartData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    QuerySnapshot snapshot =
        await transactionsRef.where('email', isEqualTo: useremail).get();

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

  @override
  void initState() {
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
        backgroundColor: Color(0xFF9489F5),
      ),
      body: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 340,
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
                                  ' $useremail',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0),
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
                              color: Color(0xFF6D5FED),
                              size: 30,
                            ),
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 42, 16, 12),
                        width: 370,
                        height: 220,
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
                ],
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
                      'Recent Transactions',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                    child: FutureBuilder(
                        future: getDocId(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: docIDs.length,
                              itemBuilder: (context, index) {
                                return GetUserTransaction(
                                    documentId: docIDs[index]);
                              });
                        }),
                  ),
                ],
              ),
            ),
          ],
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
            String tooltipText = rod.toY.round().toString();
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
              toY: totalIncome,
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
              toY: 20.21,
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
