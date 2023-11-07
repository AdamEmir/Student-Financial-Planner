// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class GetUserPiechart extends StatelessWidget {
//   const GetUserPiechart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final User? user = auth.currentUser;
//     final useremail = user?.email;
//     //get the collection
//     CollectionReference piechartdata =
//         FirebaseFirestore.instance.collection('piechartdata');
//     return FutureBuilder(
//       future: piechartdata.doc(useremail).get(),
//       builder: ((context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;

//           return List.generate(length, (index) => null);
//         }
//         return Text("No Piechart Data");
//       }),
//     );
//   }
// }
