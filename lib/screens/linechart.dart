import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class LinechartScreen extends StatefulWidget {
  const LinechartScreen({super.key});

  @override
  State<LinechartScreen> createState() => _LinechartScreenState();
}

class _LinechartScreenState extends State<LinechartScreen> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // CollectionReference transactiondata =
  //     FirebaseFirestore.instance.collection('transactions');

  // double totalExpense = 0.00;
  // double expenseJanuary = 0.00;
  // double expenseFebruary = 0.00;
  // double expenseMarch = 0.00;
  // double expenseApril = 0.00;
  // double expenseMay = 0.00;
  // double expenseJune = 0.00;
  // double expenseJuly = 0.00;
  // double expenseAugust = 0.00;
  // double expenseSeptember = 0.00;
  // double expenseOctober = 0.00;
  // double expenseNovember = 0.00;
  // double expenseDecember = 0.00;
  // String formattedexpenseNovember = '';

  // void fetchLineChartData() async {
  //   final User? user = auth.currentUser;
  //   final useremail = user?.email;

  //   QuerySnapshot snapshot =
  //       await transactiondata.where('email', isEqualTo: useremail).get();

  //   for (QueryDocumentSnapshot doc in snapshot.docs) {
  //     try {
  //       // Assuming your Firestore document structure has 'type' and 'amount' fields
  //       String transactionType = doc['transaction type'];
  //       String transactionAmount = doc['transaction amount'];
  //       Timestamp timestamp = doc['transaction date'];
  //       double calculationtransactionAmount = double.parse(transactionAmount);
  //       // Convert Timestamp to DateTime
  //       DateTime dateTime = timestamp.toDate();
  //       // Extract the month from the DateTime
  //       String month = DateFormat('MMMM').format(dateTime);

  //       if (transactionType == 'Expense') {
  //         totalExpense += calculationtransactionAmount;
  //         if (month == 'January') {
  //           expenseJanuary += calculationtransactionAmount;
  //         } else if (month == 'February') {
  //           expenseFebruary += calculationtransactionAmount;
  //         } else if (month == 'March') {
  //           expenseMarch += calculationtransactionAmount;
  //         } else if (month == 'April') {
  //           expenseApril += calculationtransactionAmount;
  //         } else if (month == 'May') {
  //           expenseMay += calculationtransactionAmount;
  //         } else if (month == 'June') {
  //           expenseJune += calculationtransactionAmount;
  //         } else if (month == 'July') {
  //           expenseJuly += calculationtransactionAmount;
  //         } else if (month == 'August') {
  //           expenseAugust += calculationtransactionAmount;
  //         } else if (month == 'September') {
  //           expenseSeptember += calculationtransactionAmount;
  //         } else if (month == 'October') {
  //           expenseOctober += calculationtransactionAmount;
  //         } else if (month == 'November') {
  //           expenseNovember += calculationtransactionAmount;
  //         } else if (month == 'December') {
  //           expenseDecember += calculationtransactionAmount;
  //         }
  //       }
  //     } catch (error) {
  //       print('Make Expense Transaction to Generate Chart');
  //     }
  //   }

  //   setState(() {});
  // }

  List<Color> gradientColors = [
    Colors.orange,
    Colors.blue,
  ];

  bool showAvg = false;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchLineChartData();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
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
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.cyan,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.cyan,
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
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
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

  //   final User? user = auth.currentUser;
  //   return Padding(
  //     padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 350,
  //           height: 250,
  //           child: Stack(
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                   right: 18,
  //                   left: 12,
  //                   top: 24,
  //                   bottom: 12,
  //                 ),
  //                 child: LineChart(
  //                   mainData(),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 10,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 0:
  //       text = const Text('JAN', style: style);
  //       break;
  //     case 1:
  //       text = const Text('FEB', style: style);
  //       break;
  //     case 2:
  //       text = const Text('MAR', style: style);
  //       break;
  //     case 3:
  //       text = const Text('APR', style: style);
  //       break;
  //     case 4:
  //       text = const Text('MAY', style: style);
  //       break;
  //     case 5:
  //       text = const Text('JUN', style: style);
  //       break;
  //     case 6:
  //       text = const Text('JULY', style: style);
  //       break;
  //     case 7:
  //       text = const Text('AUG', style: style);
  //       break;
  //     case 8:
  //       text = const Text('SEP', style: style);
  //       break;
  //     case 9:
  //       text = const Text('OCT', style: style);
  //       break;
  //     case 10:
  //       text = const Text('NOV', style: style);
  //       break;
  //     case 11:
  //       text = const Text('DEC', style: style);
  //       break;
  //     default:
  //       text = const Text('', style: style);
  //       break;
  //   }

  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: text,
  //   );
  // }

  // LineChartData mainData() {
  //   return LineChartData(
  //     gridData: FlGridData(
  //       show: false,
  //       drawVerticalLine: true,
  //       horizontalInterval: 1,
  //       verticalInterval: 1,
  //       getDrawingHorizontalLine: (value) {
  //         return const FlLine(
  //           color: Color(0xffE74852),
  //           strokeWidth: 1,
  //         );
  //       },
  //       getDrawingVerticalLine: (value) {
  //         return const FlLine(
  //           color: Color(0xffE74852),
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           interval: 1,
  //           getTitlesWidget: bottomTitleWidgets,
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         axisNameWidget: Text('Expenses (RM)'),
  //         axisNameSize: 24,
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //           reservedSize: 0,
  //         ),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: true,
  //       border: Border.all(color: const Color(0xff37434d)),
  //     ),
  //     minX: 0,
  //     maxX: 11,
  //     minY: 0,
  //     maxY: totalExpense,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: [
  //           FlSpot(0, expenseJanuary), //jan
  //           FlSpot(1, expenseFebruary), //feb
  //           FlSpot(2, expenseMarch), //march
  //           FlSpot(3, expenseApril), //april
  //           FlSpot(4, expenseMay), //may
  //           FlSpot(5, expenseJune), //june
  //           FlSpot(6, expenseJuly), //juy
  //           FlSpot(7, expenseAugust), //aug
  //           FlSpot(8, expenseSeptember), //sep
  //           FlSpot(9, expenseOctober), //oct
  //           FlSpot(10, expenseNovember), //nov
  //           FlSpot(11, expenseDecember), //dec
  //         ],
  //         isCurved: false,
  //         gradient: LinearGradient(
  //           colors: gradientColors,
  //         ),
  //         barWidth: 3,
  //         isStrokeCapRound: true,
  //         dotData: const FlDotData(
  //           show: true,
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             colors: gradientColors
  //                 .map((color) => color.withOpacity(0.3))
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
}
