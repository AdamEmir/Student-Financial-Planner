import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstly/homepage.dart';
import 'package:firstly/screens/siginintest.dart';
import 'package:firstly/screens/userprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firstly/screens/signin_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('transactions');
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  double totalIncome = 0.00;
  double totalExpense = 0.00;

  double totalIncomeDeduction = 0.00;
  String formattedtotalIncomeDeduction = '';

  String userfullname = '';

  void fetchBarchartData() async {
    final User? user = auth.currentUser;
    final useremail = user?.email;

    QuerySnapshot snapshot =
        await transactionsRef.where('email', isEqualTo: useremail).get();
    QuerySnapshot usersnapshot =
        await userRef.where('email', isEqualTo: useremail).get();

    for (QueryDocumentSnapshot doc in usersnapshot.docs) {
      // Assuming your Firestore document structure has 'type' and 'amount' fields
      String userfullnamedb = doc['fullName'];

      userfullname = userfullnamedb;
    }

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

    totalIncomeDeduction = totalIncome - totalExpense;

    formattedtotalIncomeDeduction = totalIncomeDeduction.toStringAsFixed(2);

    // Update the state to trigger a redraw of the chart
    setState(() {});
  }

  @override
  void initState() {
    fetchBarchartData();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final CollectionReference _user =
        FirebaseFirestore.instance.collection('Users');
    final User? user = auth.currentUser;
    final useremail = user?.email;

    final userRef = FirebaseFirestore.instance.collection('Users');
    final query = userRef.where('email', isEqualTo: useremail);

    return Scaffold(
      body: // Generated code for this Container Widget...
          Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Text(
                  '$userfullname',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Color(0xFFFFFFFF)),
                ),
              ),
              Divider(
                height: 44,
                thickness: 1,
                indent: 24,
                endIndent: 24,
                color: Color(0xFFFFFFFF),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                child: Text(
                  'Wallet Balance',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Color(0xFFFFFFFF)),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: Text(
                  'RM $formattedtotalIncomeDeduction',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 45.0,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFFE0E3E7),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                            child: Icon(
                              Icons.person_3_rounded,
                              color: Color(0xFF101213),
                              size: 24,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: Color(0xFF101213)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
              //   child: Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Color(0xFFFFFFFF),
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(
              //         color: Color(0xFFE0E3E7),
              //         width: 2,
              //       ),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           Padding(
              //             padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
              //             child: Icon(
              //               Icons.password,
              //               color: Color(0xFF101213),
              //               size: 24,
              //             ),
              //           ),
              //           Padding(
              //             padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              //             child: Text(
              //               'Reset Password',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 16.0,
              //                   color: Color(0xFF101213)),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                child: GestureDetector(
                  onTap: () {
                    //pop up modal here
                    _showResetConfirmationDialog(context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFFE0E3E7),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                            child: Icon(
                              Icons.construction,
                              color: Color(0xFF101213),
                              size: 24,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Reset Data',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: Color(0xFF101213)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Container(
                  width: 150,
                  height: 50,
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(
                      color: Color(0xFFE0E3E7),
                      width: 1,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Show a loading indicator.
                      setState(() {
                        isLoading = true;
                      });

                      // Log out the user from the Firebase database.
                      await FirebaseAuth.instance.signOut();

                      // Hide the loading indicator.
                      setState(() {
                        isLoading = false;
                      });

                      // Redirect the user to the login page.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SigninTestScreen()));
                      Fluttertoast.showToast(
                        msg: "Succesfully log out",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        fontSize: 16.0,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color(0xFF24A891);
                        }
                        return Colors.white;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: Color(0xFF101213),
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

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Data', style: TextStyle(color: Color(0xFF9489F5))),
          backgroundColor: Colors.white,
          content: Text(
            'Are you sure you want to reset your data?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Add code to handle 'Yes' button press
                // For example, you can reset the data here
                // Assuming you have a unique ID for each document
                final User? user = auth.currentUser;
                final useremail = user?.email;

                // Delete documents in the 'transactions' collection
                QuerySnapshot transactionsSnapshot = await transactionsRef
                    .where('email', isEqualTo: useremail)
                    .get();

                for (QueryDocumentSnapshot doc in transactionsSnapshot.docs) {
                  // Assuming your Firestore document structure has 'documentId' field
                  String documentId = doc.id;

                  // Delete the document
                  await transactionsRef.doc(documentId).delete();
                }

                // Delete documents in the 'savings' collection
                QuerySnapshot savingsSnapshot = await FirebaseFirestore.instance
                    .collection('savings')
                    .where('email', isEqualTo: useremail)
                    .get();

                for (QueryDocumentSnapshot doc in savingsSnapshot.docs) {
                  String documentId = doc.id;
                  await FirebaseFirestore.instance
                      .collection('savings')
                      .doc(documentId)
                      .update({
                    'savings percentage': '0%',
                  });
                }

                // Delete documents in the 'userbarchartmax' collection
                QuerySnapshot userBarchartMaxSnapshot = await FirebaseFirestore
                    .instance
                    .collection('userbarchartmax')
                    .where('email', isEqualTo: useremail)
                    .get();

                for (QueryDocumentSnapshot doc
                    in userBarchartMaxSnapshot.docs) {
                  String documentId = doc.id;
                  await FirebaseFirestore.instance
                      .collection('userbarchartmax')
                      .doc(documentId)
                      .delete();
                }

                Navigator.of(context).pop(); // Close the dialog
                Fluttertoast.showToast(
                  msg: 'Data deleted Successfully',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              style: TextButton.styleFrom(
                primary: Color(0xFF9489F5), // Set 'Yes' button text color
              ),
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                primary: Color(0xFF9489F5), // Set 'No' button text color
              ),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
