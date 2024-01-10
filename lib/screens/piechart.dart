import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';

class PiechartScreen extends StatefulWidget {
  const PiechartScreen({Key? key}) : super(key: key);

  @override
  State<PiechartScreen> createState() => _PiechartScreenState();
}

class _PiechartScreenState extends State<PiechartScreen> {
  int touchedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference transactiondata =
      FirebaseFirestore.instance.collection('transactions');

  @override
  void initState() {
    super.initState();
    _updateExpenseData();
  }

  Future<void> _updateExpenseData() async {
    List<PieChartSectionData> sections = await fetchExpenseData();
    setState(() {
      _sections = sections;
    });
  }

  Future<List<PieChartSectionData>> fetchExpenseData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    QuerySnapshot snapshot =
        await transactiondata.where('email', isEqualTo: useremail).get();

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

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ),
    );
  }
}
