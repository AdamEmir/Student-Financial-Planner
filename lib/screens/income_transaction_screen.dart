// import 'package:flutter/material.dart';
// import 'package:firstly/models/income_transaction_screen_model.dart';

// class IncomeTransactionScreen extends StatefulWidget {
//   const IncomeTransactionScreen({super.key});

//   @override
//   State<IncomeTransactionScreen> createState() =>
//       _IncomeTransactionScreenState();
// }

// class _IncomeTransactionScreenState extends State<IncomeTransactionScreen>
//     with TickerProviderStateMixin {
//   late IncomeTransactionScreenModel _model;
//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => IncomeTransactionScreenModel());

//     _model.tabBarController = TabController(
//       vsync: this,
//       length: 2,
//       initialIndex: 0,
//     )..addListener(() => setState(() {}));
//     _model.userIncomeController1 ??= TextEditingController();
//     _model.userIncomeFocusNode1 ??= FocusNode();
//     _model.userIncomeController2 ??= TextEditingController();
//     _model.userIncomeFocusNode2 ??= FocusNode();
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: // Generated code for this Column Widget...
//           Column(
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment(0, 0),
//                   child: TabBar(
//                     labelColor: Color(0xFF39D2C0),
//                     unselectedLabelColor: Color(0xFF57636C),
//                     labelStyle:
//                         TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
//                     unselectedLabelStyle: TextStyle(),
//                     indicatorColor: Color(0xFF39D2C0),
//                     indicatorWeight: 5,
//                     padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
//                     tabs: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
//                             child: Icon(
//                               Icons.trending_up_rounded,
//                             ),
//                           ),
//                           Tab(
//                             text: 'Income',
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
//                             child: Icon(
//                               Icons.trending_down_rounded,
//                             ),
//                           ),
//                           Tab(
//                             text: 'Transaction',
//                           ),
//                         ],
//                       ),
//                     ],
//                     controller: _model.tabBarController,
//                   ),
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     controller: _model.tabBarController,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: double.infinity,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Color(0xFF9489F5), Color(0xFF6D5FED)],
//                             stops: [0, 1],
//                             begin: AlignmentDirectional(0, -1),
//                             end: AlignmentDirectional(0, 1),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 180, 0, 0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     16, 16, 16, 16),
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 390,
//                                   decoration: BoxDecoration(
//                                     color: Color(0xFFFFFFFF),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Align(
//                                     alignment: AlignmentDirectional(0.00, 0.00),
//                                     child: Padding(
//                                       padding: EdgeInsetsDirectional.fromSTEB(
//                                           32, 32, 32, 32),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             'State Your Income',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 35.0,
//                                               color: Color(0xFF101213),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 12, 0, 24),
//                                             child: Text(
//                                               'State your income by filling out the form below.',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 14.0,
//                                                 color: Color(0xFF101213),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 0, 0, 16),
//                                             child:
//                                                 DropdownButton<String>(items: [
//                                               DropdownMenuItem(
//                                                 child: Text('Cash'),
//                                                 value: 'Cash',
//                                               ),DropdownMenuItem(
//                                                 child: Text('Card'),
//                                                 value: 'Card',
//                                               ),DropdownMenuItem(
//                                                 child: Text('Allowance'),
//                                                 value: 'Allowance',
//                                               ),
//                                             ],onChanged: (value){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You selected $value'),),);},)
//                                             child: FlutterFlowDropDown<String>(
//                                               controller: _model
//                                                       .dropDownValueController1 ??=
//                                                   FormFieldController<String>(
//                                                       null),
//                                               options: [
//                                                 'Cash',
//                                                 'Card',
//                                                 'Allowance'
//                                               ],
//                                               onChanged: (val) => setState(() =>
//                                                   _model.dropDownValue1 = val),
//                                               width: 300,
//                                               height: 50,
//                                               textStyle:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyMedium
//                                                       .override(
//                                                         fontFamily: 'Manrope',
//                                                         fontSize: 14,
//                                                       ),
//                                               hintText: 'Please select...',
//                                               icon: Icon(
//                                                 Icons
//                                                     .keyboard_arrow_down_rounded,
//                                                 color:
//                                                     FlutterFlowTheme.of(context)
//                                                         .secondaryText,
//                                                 size: 24,
//                                               ),
//                                               fillColor:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primaryBackground,
//                                               elevation: 2,
//                                               borderColor:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               borderWidth: 2,
//                                               borderRadius: 8,
//                                               margin: EdgeInsetsDirectional
//                                                   .fromSTEB(16, 4, 16, 4),
//                                               hidesUnderline: true,
//                                               isSearchable: false,
//                                               isMultiSelect: false,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 0, 0, 16),
//                                             child: Container(
//                                               width: double.infinity,
//                                               child: TextFormField(
//                                                 controller: _model
//                                                     .userIncomeController1,
//                                                 focusNode:
//                                                     _model.userIncomeFocusNode1,
//                                                 autofocus: true,
//                                                 obscureText: false,
//                                                 decoration: InputDecoration(
//                                                   labelText: 'Income Amount',
//                                                   labelStyle:
//                                                       FlutterFlowTheme.of(
//                                                               context)
//                                                           .labelLarge,
//                                                   alignLabelWithHint: false,
//                                                   hintStyle:
//                                                       FlutterFlowTheme.of(
//                                                               context)
//                                                           .labelMedium,
//                                                   enabledBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color: FlutterFlowTheme
//                                                               .of(context)
//                                                           .primaryBackground,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .primary,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   errorBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .alternate,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   focusedErrorBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .alternate,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   filled: true,
//                                                   fillColor:
//                                                       FlutterFlowTheme.of(
//                                                               context)
//                                                           .primaryBackground,
//                                                 ),
//                                                 style:
//                                                     FlutterFlowTheme.of(context)
//                                                         .bodyLarge
//                                                         .override(
//                                                           fontFamily: 'Manrope',
//                                                           fontSize: 16,
//                                                         ),
//                                                 keyboardType:
//                                                     const TextInputType
//                                                         .numberWithOptions(
//                                                         decimal: true),
//                                                 validator: _model
//                                                     .userIncomeController1Validator
//                                                     .asValidator(context),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 16, 0, 16),
//                                             child: FFButtonWidget(
//                                               onPressed: () {
//                                                 print('Button pressed ...');
//                                               },
//                                               text: 'Submit',
//                                               options: FFButtonOptions(
//                                                 width: double.infinity,
//                                                 height: 44,
//                                                 padding: EdgeInsetsDirectional
//                                                     .fromSTEB(24, 0, 24, 0),
//                                                 iconPadding:
//                                                     EdgeInsetsDirectional
//                                                         .fromSTEB(0, 0, 0, 0),
//                                                 color:
//                                                     FlutterFlowTheme.of(context)
//                                                         .primary,
//                                                 textStyle:
//                                                     FlutterFlowTheme.of(context)
//                                                         .titleSmall
//                                                         .override(
//                                                           fontFamily: 'Manrope',
//                                                           color: Colors.white,
//                                                         ),
//                                                 elevation: 3,
//                                                 borderSide: BorderSide(
//                                                   color: Colors.transparent,
//                                                   width: 1,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: double.infinity,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               FlutterFlowTheme.of(context).primary,
//                               FlutterFlowTheme.of(context).tertiary
//                             ],
//                             stops: [0, 1],
//                             begin: AlignmentDirectional(0, -1),
//                             end: AlignmentDirectional(0, 1),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 180, 0, 0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     16, 16, 16, 16),
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 390,
//                                   decoration: BoxDecoration(
//                                     color: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Align(
//                                     alignment: AlignmentDirectional(0.00, 0.00),
//                                     child: Padding(
//                                       padding: EdgeInsetsDirectional.fromSTEB(
//                                           32, 32, 32, 32),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 0, 0, 7),
//                                             child: Text(
//                                               'State Your Transaction',
//                                               textAlign: TextAlign.center,
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .displaySmall
//                                                       .override(
//                                                         fontFamily: 'Urbanist',
//                                                         fontSize: 29,
//                                                       ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 12, 0, 24),
//                                             child: Text(
//                                               'State your transaction by filling out the form below.',
//                                               textAlign: TextAlign.center,
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .labelLarge,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 0, 0, 16),
//                                             child: FlutterFlowDropDown<String>(
//                                               controller: _model
//                                                       .dropDownValueController2 ??=
//                                                   FormFieldController<String>(
//                                                       null),
//                                               options: [
//                                                 'Shopping',
//                                                 'Food & Beverage',
//                                                 'Transportation',
//                                                 'Electronics',
//                                                 'Other Expenses'
//                                               ],
//                                               onChanged: (val) => setState(() =>
//                                                   _model.dropDownValue2 = val),
//                                               width: 300,
//                                               height: 50,
//                                               textStyle:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyMedium
//                                                       .override(
//                                                         fontFamily: 'Manrope',
//                                                         fontSize: 14,
//                                                       ),
//                                               hintText: 'Please select...',
//                                               icon: Icon(
//                                                 Icons
//                                                     .keyboard_arrow_down_rounded,
//                                                 color:
//                                                     FlutterFlowTheme.of(context)
//                                                         .secondaryText,
//                                                 size: 24,
//                                               ),
//                                               fillColor:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primaryBackground,
//                                               elevation: 2,
//                                               borderColor:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               borderWidth: 2,
//                                               borderRadius: 8,
//                                               margin: EdgeInsetsDirectional
//                                                   .fromSTEB(16, 4, 16, 4),
//                                               hidesUnderline: true,
//                                               isSearchable: false,
//                                               isMultiSelect: false,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 0, 0, 16),
//                                             child: Container(
//                                               width: double.infinity,
//                                               child: TextFormField(
//                                                 controller: _model
//                                                     .userIncomeController2,
//                                                 focusNode:
//                                                     _model.userIncomeFocusNode2,
//                                                 autofocus: true,
//                                                 obscureText: false,
//                                                 decoration: InputDecoration(
//                                                   labelText:
//                                                       'Transaction Amount',
//                                                   labelStyle:
//                                                       FlutterFlowTheme.of(
//                                                               context)
//                                                           .labelLarge,
//                                                   alignLabelWithHint: false,
//                                                   hintStyle:
//                                                       FlutterFlowTheme.of(
//                                                               context)
//                                                           .labelMedium,
//                                                   enabledBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color: FlutterFlowTheme
//                                                               .of(context)
//                                                           .primaryBackground,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .primary,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   errorBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .alternate,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   focusedErrorBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .alternate,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                   ),
//                                                   filled: true,
//                                                   fillColor:
//                                                       FlutterFlowTheme.of(
//                                                               context)
//                                                           .primaryBackground,
//                                                 ),
//                                                 style:
//                                                     FlutterFlowTheme.of(context)
//                                                         .bodyLarge
//                                                         .override(
//                                                           fontFamily: 'Manrope',
//                                                           fontSize: 16,
//                                                         ),
//                                                 keyboardType:
//                                                     const TextInputType
//                                                         .numberWithOptions(
//                                                         decimal: true),
//                                                 validator: _model
//                                                     .userIncomeController2Validator
//                                                     .asValidator(context),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 16, 0, 16),
//                                             child: FFButtonWidget(
//                                               onPressed: () {
//                                                 print('Button pressed ...');
//                                               },
//                                               text: 'Submit',
//                                               options: FFButtonOptions(
//                                                 width: double.infinity,
//                                                 height: 44,
//                                                 padding: EdgeInsetsDirectional
//                                                     .fromSTEB(24, 0, 24, 0),
//                                                 iconPadding:
//                                                     EdgeInsetsDirectional
//                                                         .fromSTEB(0, 0, 0, 0),
//                                                 color:
//                                                     FlutterFlowTheme.of(context)
//                                                         .primary,
//                                                 textStyle:
//                                                     FlutterFlowTheme.of(context)
//                                                         .titleSmall
//                                                         .override(
//                                                           fontFamily: 'Manrope',
//                                                           color: Colors.white,
//                                                         ),
//                                                 elevation: 3,
//                                                 borderSide: BorderSide(
//                                                   color: Colors.transparent,
//                                                   width: 1,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
