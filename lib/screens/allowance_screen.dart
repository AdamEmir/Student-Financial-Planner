import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/reusable_widgets/reusable_widget.dart';
import 'package:firstly/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AllowanceScreen extends StatefulWidget {
  const AllowanceScreen({super.key});

  @override
  State<AllowanceScreen> createState() => _AllowanceScreenState();
}

class _AllowanceScreenState extends State<AllowanceScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  DateTime _currentDate = DateTime.now();
  TextEditingController _allowanceController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  handleSubmitAllowance() async {
    final allowance = int.parse(_allowanceController.value.text);
    final date = _dateController.value.text;
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final currentAllowance = await getAllowance(useremail!);

    final totalallowance = currentAllowance + allowance;

    addAllowance(totalallowance, date, useremail!);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));

    Fluttertoast.showToast(
      msg: 'Allowance Inserted Successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future addAllowance(int totalallowance, String date, String useremail) async {
    await FirebaseFirestore.instance
        .collection('Allowance')
        .doc(useremail)
        .set({
      'allowance': totalallowance,
      'updated_at': Timestamp.now(),
      'email': useremail,
    });
  }

  Future getAllowance(String useremail) async {
    final expensesRef =
        FirebaseFirestore.instance.collection('Allowance').doc(useremail);
    final expensesDoc = await expensesRef.get();
    if (expensesDoc.exists) {
      return expensesDoc.get('allowance');
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Text(
      //     "Allowance",
      //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.teal[200],
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              reusableNumField("Allowance", Icons.person_outline, false,
                  _allowanceController),
              const SizedBox(
                height: 30,
              ),
              reusableCalenderField("Date: ${_dateController.text}",
                  Icons.calendar_month_rounded, false, _dateController),
              const SizedBox(
                height: 30,
              ),
              submitButton(context, false, () {
                handleSubmitAllowance();
              })
            ]),
          ),
        ),
      ),
    );
  }
}
