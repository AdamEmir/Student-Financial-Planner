import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PiechartScreen extends StatefulWidget {
  const PiechartScreen({super.key});
  @override
  State<PiechartScreen> createState() => _PiechartScreenState();
}

class _PiechartScreenState extends State<PiechartScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get the collection reference
  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');
  CollectionReference barchartMaxRef =
      FirebaseFirestore.instance.collection('userbarchartmax');
  double totalIncome = 0.00;
  double totalExpense = 0.00;
  double parsebarchartMax = 0.00;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchBarcharMax();
  }

  void fetchData() async {
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

  void fetchBarcharMax() async {
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

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final useremail = user?.email;
    return Container(
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
