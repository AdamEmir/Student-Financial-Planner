import 'package:firstly/screens/analytic_screen.dart';
import 'package:firstly/screens/expenses_screen.dart';
import 'package:firstly/screens/home_screen.dart';
import 'package:firstly/screens/legend_screen.dart';
import 'package:firstly/screens/linechart.dart';
import 'package:firstly/screens/piechart.dart';
import 'package:firstly/screens/profile_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeScreen(),
    ExpensesScreen(),
    AnalyticScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF39D2C0),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_rounded), label: 'Expense'),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart), label: 'Analytic'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
