// import 'package:flutter/material.dart';
// import 'package:firstly/screens/income_transaction_screen.dart'
//     show IncomeTransactionScreen;

// class IncomeTransactionScreenModel
//     extends FlutterFlowModel<IncomeTransactionScreen> {
//   ///  State fields for stateful widgets in this page.

//   final unfocusNode = FocusNode();
//   // State field(s) for TabBar widget.
//   TabController? tabBarController;
//   int get tabBarCurrentIndex =>
//       tabBarController != null ? tabBarController!.index : 0;

//   // State field(s) for DropDown widget.
//   String? dropDownValue1;
//   FormFieldController<String>? dropDownValueController1;
//   // State field(s) for userIncome widget.
//   FocusNode? userIncomeFocusNode1;
//   TextEditingController? userIncomeController1;
//   String? Function(BuildContext, String?)? userIncomeController1Validator;
//   // State field(s) for DropDown widget.
//   String? dropDownValue2;
//   FormFieldController<String>? dropDownValueController2;
//   // State field(s) for userIncome widget.
//   FocusNode? userIncomeFocusNode2;
//   TextEditingController? userIncomeController2;
//   String? Function(BuildContext, String?)? userIncomeController2Validator;

//   /// Initialization and disposal methods.

//   void initState(BuildContext context) {}

//   void dispose() {
//     unfocusNode.dispose();
//     tabBarController?.dispose();
//     userIncomeFocusNode1?.dispose();
//     userIncomeController1?.dispose();

//     userIncomeFocusNode2?.dispose();
//     userIncomeController2?.dispose();
//   }

//   /// Action blocks are added here.

//   /// Additional helper methods are added here.
// }
