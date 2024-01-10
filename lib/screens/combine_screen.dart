import 'package:firstly/screens/allowance_screen.dart';
import 'package:firstly/screens/expenses_transaction_screen.dart';
import 'package:firstly/screens/savings_screen.dart';
import 'package:flutter/material.dart';
export 'package:firstly/screens/combine_screen.dart';

class CombineScreen extends StatefulWidget {
  const CombineScreen({super.key});

  @override
  State<CombineScreen> createState() => CombineScreenState();
}

class CombineScreenState extends State<CombineScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Color(0xFF9489F5)),
        backgroundColor: Color(0xFFFFFFFF),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF39D2C0),
          unselectedLabelColor: Color(0xFF57636C),
          labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
          unselectedLabelStyle: TextStyle(),
          indicatorColor: Color(0xFF39D2C0),
          indicatorWeight: 5,
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
          tabs: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Icon(
                    Icons.trending_up_rounded,
                  ),
                ),
                Tab(
                  text: 'Income',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Icon(
                    Icons.savings_rounded,
                  ),
                ),
                Tab(
                  text: 'Savings',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Icon(
                    Icons.trending_down_rounded,
                  ),
                ),
                Tab(
                  text: 'Expenses',
                ),
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          AllowanceScreen(),
          SavingsScreen(),
          ExpensesTransactionScreen(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }
}
