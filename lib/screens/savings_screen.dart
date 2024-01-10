import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final savingsNameController = TextEditingController();
  final savingsDescriptionController = TextEditingController();
  final savingsDateController = TextEditingController();

  String dropdownValue = '0%';

  // Get the collection reference
  CollectionReference savingsRef =
      FirebaseFirestore.instance.collection('savings');

  void saveDataToFirestore(String dropdownValue, String savingsName,
      String savingsDescription, String savingsDate) async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    // Convert selectedDate to Timestamp
    final timestamp = Timestamp.fromDate(selectedDate);

    // Get the user's unique ID (you can use the user's email as well)
    if (useremail != null) {
      savingsRef.doc(useremail).update({
        'email': useremail,
        'savings name': savingsName,
        'savings percentage': dropdownValue,
        'savings description': savingsDescription,
        'savings date': timestamp,
        'savings date created': Timestamp.now(),
      }).then((value) {
        // Data added successfully
        print('Data added to Firestore.');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        Fluttertoast.showToast(
          msg: 'Savings set Successfully',
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

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Set both date and time parts
      final DateTime selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDate.hour,
        selectedDate.minute,
        selectedDate.second,
      );

      setState(() {
        selectedDate = selectedDateTime;
        savingsDateController.text =
            DateFormat("dd MMMM yyyy , hh:mm:ss a").format(selectedDateTime);
      });
    }
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
                image: DecorationImage(
              image: AssetImage("assets/images/bg2.png"),
              fit: BoxFit.cover,
            )),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Container(
                      width: double.infinity,
                      height: 540,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'State Your Savings',
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
                                      'State your savings by filling out the form below.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: Color(0xFF57636C)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 16, 0),
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF1F4F8),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Color(0xFFE0E3E7),
                                              width: 2)),
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
                                              '0%',
                                              '5%',
                                              '10%',
                                              '15%',
                                              '20%',
                                              '25%'
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            icon: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Color(0xFF57636C),
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Income Description Start
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: savingsNameController,
                                        decoration: InputDecoration(
                                          labelText: 'Savings Name',
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9489F5),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE74852),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: Color(0xFF101213)),
                                      ),
                                    ),
                                  ),
                                  //Income Description Ends
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller:
                                            savingsDescriptionController,
                                        decoration: InputDecoration(
                                          labelText: 'Description',
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9489F5),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE74852),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: Color(0xFF101213)),
                                      ),
                                    ),
                                  ),
                                  //Income Date Start
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: savingsDateController,
                                        onTap: () => _selectDate(context),
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Date',
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF9489F5),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE0E3E7),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFE74852),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: Color(0xFF101213)),
                                      ),
                                    ),
                                  ),
                                  //Income Date Ends
                                  //Submit Button Start
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 16),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 1,
                                          )),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                MaterialState.pressed)) {
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
                                          String savingsName =
                                              savingsNameController.text;

                                          String savingsDecription =
                                              savingsDescriptionController.text;

                                          String savingsDate =
                                              savingsDateController.text;

                                          saveDataToFirestore(
                                              selectedDropdownValue,
                                              savingsName,
                                              savingsDecription,
                                              savingsDate);
                                        },
                                        child: const Text(
                                          "Set",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Submit Button Ends
                                ],
                              ),
                              Positioned(
                                left: 13, // Adjust the position as needed
                                top: 87, // Adjust the position as needed
                                child: Text(
                                  'Savings Percentage',
                                  style: TextStyle(
                                      color: Color(0xFF57636C),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.0,
                                      backgroundColor: Colors.white),
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
