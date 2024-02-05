import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UpdateTransactionScreen extends StatefulWidget {
  final DocumentSnapshot transactionData;
  const UpdateTransactionScreen({required this.transactionData, Key? key});

  @override
  State<UpdateTransactionScreen> createState() =>
      _UpdateTransactionScreenState();
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');
  // You can use controllers to pre-fill the form fields with existing data
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String dropdownValue = 'Shopping';
  String transactiontype = '';
  String temporaryDeductionBarchartMax = '';

  String formatTransactionDate(Timestamp timestamp) {
    // Convert the timestamp to a DateTime object
    final DateTime dateTime = timestamp.toDate();

    // Format the DateTime object using the desired format
    final DateFormat formatter = DateFormat('MMM. dd, HH:mm');

    // Return the formatted date string
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    // Set the initial values based on the existing data
    transactiontype = widget.transactionData['transaction type'];
    dropdownValue = widget.transactionData['transaction category'];
    _amountController.text =
        widget.transactionData['transaction amount'].toString();
    _descriptionController.text =
        widget.transactionData['transaction description'];
    _dateController.text =
        formatTransactionDate(widget.transactionData['transaction date']);
    temporaryDeductionBarchartMax =
        widget.transactionData['transaction amount'];
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
        _dateController.text =
            DateFormat("dd MMMM yyyy , hh:mm:ss a").format(selectedDateTime);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6D5FED),
        elevation: 0,
        title: const Text(
          "Transaction Edit",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
          fit: BoxFit.cover,
        )),
        alignment: AlignmentDirectional(0.00, -2.50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: Container(
                  width: 300,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: AlignmentDirectional(0.00, 0.00),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 570,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Update Your Transaction',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25.0,
                                color: Color(0xFF101213)),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                            child: Text(
                              "Edit transaction by filling out the form below.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: Color(0xFF57636C)),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                            child: Container(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF1F4F8),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Color(0xFFE0E3E7), width: 2)),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(11, 0, 0, 0),
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
                                    items: transactiontype == 'Income'
                                        ? <String>[
                                            'Allowance',
                                            'Business',
                                            'Salary',
                                            'Others'
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList()
                                        : <String>[
                                            'Shopping',
                                            'Electronic',
                                            'Transportation',
                                            'FoodandBeverage',
                                            'OtherExpenses'
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                    icon: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
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
                                controller: _amountController,
                                decoration: InputDecoration(
                                  labelText: 'Transaction Amount',
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
                          //Income Description Start
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _descriptionController,
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
                              ),
                            ),
                          ),
                          //Income Description Ends
                          //Income Date Start
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _dateController,
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
                              ),
                            ),
                          ),
                          //Income Date Ends
                          //Submit Button Start
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
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
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  String selectedDropdownValue = dropdownValue;
                                  double transactionAmount =
                                      double.parse(_amountController.text);

                                  String transactionDecription =
                                      _descriptionController.text;

                                  String transactionDate = _dateController.text;

                                  saveDataToFirestore(
                                      selectedDropdownValue,
                                      transactionAmount,
                                      transactionDecription,
                                      transactionDate);
                                },
                                child: const Text(
                                  "Update",
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
    );
  }

  void saveDataToFirestore(
      String selectedDropdownValue,
      double transactionAmount,
      String transactionDecription,
      String transactionDate) async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final formattedIncomeAmount = transactionAmount.toStringAsFixed(2);

    // Convert selectedDate to Timestamp
    final timestamp = Timestamp.fromDate(selectedDate);
    final calculationBarchartMax = double.parse(temporaryDeductionBarchartMax);

    if (transactiontype == 'Income') {
      final temporaryBarchartMax = await getUserbarchartmax(useremail!);

      final totalbarchartmax =
          temporaryBarchartMax - calculationBarchartMax + transactionAmount;

      setUserbarchartmax(totalbarchartmax, useremail);
    }

    if (useremail != null) {
      try {
        final userDoc =
            await transactionsRef.where('email', isEqualTo: useremail).get();
        if (userDoc.docs.isNotEmpty) {
          final docId = userDoc.docs.first.id;
          await transactionsRef.doc(widget.transactionData.id).update({
            'email': useremail,
            'transaction amount': formattedIncomeAmount,
            'transaction category': dropdownValue,
            'transaction type': transactiontype,
            'transaction description': transactionDecription,
            'transaction date': timestamp,
            'transaction date created': Timestamp.now(),
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );

          Fluttertoast.showToast(
            msg: 'Data updated successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'User not found',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (error) {
        print('Error updating data in Firestore: $error');
        Fluttertoast.showToast(
          msg: 'Data update failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }
}
