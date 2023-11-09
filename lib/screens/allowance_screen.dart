import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/homepage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllowanceScreen extends StatefulWidget {
  const AllowanceScreen({super.key});

  @override
  State<AllowanceScreen> createState() => _AllowanceScreenState();
}

class _AllowanceScreenState extends State<AllowanceScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final incomeAmountController = TextEditingController();
  String dropdownValue = 'Cash';

  // Get the collection reference
  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');

  void saveDataToFirestore(String dropdownValue, double incomeAmount) async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final currentbarchartmax = await getUserbarchartmax(useremail!);

    final totalbarchartmax = currentbarchartmax + incomeAmount;

    setUserbarchartmax(totalbarchartmax, useremail);

    final formattedIncomeAmout = incomeAmount.toStringAsFixed(2);

    // Get the user's unique ID (you can use the user's email as well)
    if (useremail != null) {
      transactionsRef.add({
        'email': useremail,
        'transaction amount': formattedIncomeAmout,
        'transaction category': dropdownValue,
        'transaction date': Timestamp.now(),
        'transaction type': 'Income'
      }).then((value) {
        // Data added successfully
        print('Data added to Firestore.');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        Fluttertoast.showToast(
          msg: 'Data added Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }).catchError((error) {
        // Error handling
        print('Error adding data to Firestore: $error');
        Fluttertoast.showToast(
          msg: 'Data added Failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      });
    }
  }

  Future getUserbarchartmax(String useremail) async {
    final UserbarchartmaxRef =
        FirebaseFirestore.instance.collection('userbarchartmax').doc(useremail);
    final UserbarchartmaxDoc = await UserbarchartmaxRef.get();
    if (UserbarchartmaxDoc.exists) {
      return double.parse(UserbarchartmaxDoc.get('barchartmax'));
    } else {
      return 0;
    }
  }

  Future setUserbarchartmax(double totalbarchartmax, String useremail) async {
    await FirebaseFirestore.instance
        .collection('userbarchartmax')
        .doc(useremail)
        .set({
      'barchartmax': totalbarchartmax.toString(),
      'updated at': Timestamp.now(),
      'email': useremail,
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final useremail = user?.email;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 790,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9489F5), Color(0xFF6D5FED)],
                stops: [0, 1],
                begin: AlignmentDirectional(0, -1),
                end: AlignmentDirectional(0, 1),
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Container(
                      width: double.infinity,
                      height: 390,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'State Your Income',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 35.0,
                                    color: Color(0xFF101213)),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 24),
                                child: Text(
                                  'State your income by filling out the form below.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Color(0xFF57636C)),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                child: Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF1F4F8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Color(0xFFE0E3E7), width: 2)),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        11, 0, 0, 0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        elevation: 8,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                            color: Color(0xFF101213)),
                                        value: dropdownValue,
                                        onChanged: (String? newValue) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Cash',
                                          'Card',
                                          'Allowance'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        icon: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Color(0xFF57636C),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: incomeAmountController,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Income Amount',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: Color(0xFF57636C)),
                                      alignLabelWithHint: false,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          color: Color(0xFF57636C)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF9489F5),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE0E3E7),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE74852),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF1F4F8),
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                        color: Color(0xFF101213)),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 16, 0, 16),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1,
                                      )),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Color(0xFF6D5FED);
                                        }
                                        return Color(0xFF9489F5);
                                      }),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      String selectedDropdownValue =
                                          dropdownValue;
                                      double incomeAmount = double.parse(
                                          incomeAmountController.text);

                                      saveDataToFirestore(
                                          selectedDropdownValue, incomeAmount);
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
