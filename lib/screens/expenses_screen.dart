import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/models/get_user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        .orderBy('transaction date', descending: true)
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

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final useremail = user?.email;
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
                        'Expenses Details',
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
                        'Pie Chart',
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
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 42, 16, 12),
                          child: Container(
                            width: 370,
                            height: 230,
                            child: FutureBuilder<DocumentSnapshot>(
                              future: piechartdata.doc(useremail).get(),
                              builder: ((contet, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  // Extract shopping and electronic data from Firestore
                                  int shoppingPercent =
                                      data['shopping percent'] ?? 0;
                                  String shoppingTitle =
                                      data['shopping title'] ?? '';
                                  int electronicPercent =
                                      data['electronic percent'] ?? 0;
                                  String electronicTitle =
                                      data['electronic title'] ?? '';
                                  int transportationPercent =
                                      data['transportation percent'] ?? 0;
                                  String transportationTitle =
                                      data['transportation title'] ?? '';
                                  int foodandbeveragePercent =
                                      data['foodandbeverage percent'] ?? 0;
                                  String foodandbeverageTitle =
                                      data['foodandbeverage title'] ?? '';
                                  int otherexpensesPercent =
                                      data['otherexpenses percent'] ?? 0;
                                  String otherexpensesTitle =
                                      data['otherexpenses title'] ?? '';
                                  return AspectRatio(
                                    aspectRatio: 1.3,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: PieChart(
                                        PieChartData(
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 0,
                                          sections: showingSections(
                                            shoppingPercent,
                                            shoppingTitle,
                                            electronicPercent,
                                            electronicTitle,
                                            transportationPercent,
                                            transportationTitle,
                                            foodandbeveragePercent,
                                            foodandbeverageTitle,
                                            otherexpensesPercent,
                                            otherexpensesTitle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const Text("No piechart data");
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: SingleChildScrollView(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      int shoppingPercent,
      String shoppingTitle,
      int electronicPercent,
      String electronicTitle,
      int transportationPercent,
      String transportationTitle,
      int foodandbeveragePercent,
      String foodandbeverageTitle,
      int otherexpensesPercent,
      String otherexpensesTitle) {
    return List.generate(5, (i) {
      // final isTouched = i == touchedIndex;
      final fontSize = 16.0;
      final radius = 125.0;
      final widgetSize = 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xff39D2C0),
            value: shoppingPercent.toDouble(),
            title: shoppingTitle + "%",
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
                Icons.shopping_cart,
                size: widgetSize - 8,
                color: Color(0xff39D2C0),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xff6D5FED),
            value: electronicPercent.toDouble(),
            title: electronicTitle + "%",
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
                Icons.laptop_rounded,
                size: widgetSize - 8,
                color: Color(0xff6D5FED),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xffE74852),
            value: transportationPercent.toDouble(),
            title: transportationTitle + "%",
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
                Icons.train_rounded,
                size: widgetSize - 8,
                color: Color(0xffE74852),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Color(0xffFF6D33),
            value: foodandbeveragePercent.toDouble(),
            title: foodandbeverageTitle + "%",
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
                color: Color(0xffFF6D33),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: Color(0xff4D6D5FED),
            value: otherexpensesPercent.toDouble(),
            title: otherexpensesTitle + "%",
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
                color: Color(0xff4D6D5FED),
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
    );
  }
}
