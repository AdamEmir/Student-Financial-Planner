import 'package:firstly/screens/addexpense_screen.dart';
import 'package:firstly/screens/allowance_screen.dart';
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
    _tabController = TabController(length: 2, vsync: this);
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
        backgroundColor: Color(0xFF9489F5),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF39D2C0),
          unselectedLabelColor: Color(0xFF57636C),
          labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
          unselectedLabelStyle: TextStyle(),
          indicatorColor: Color(0xFF39D2C0),
          indicatorWeight: 5,
          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
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
                    Icons.trending_down_rounded,
                  ),
                ),
                Tab(
                  text: 'Transaction',
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
          AddExpenseScreen(),
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
