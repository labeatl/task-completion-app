//import 'package:flutter/material.dart';
//import 'package:auto_size_text/auto_size_text.dart';
//
//class errorMSG extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() => new errorMSGState();
//  String warn;
//  errorMSG(this.warn);
//
//  String returnWarn() {
//    String test = warn;
//    return test;
//  }
//}
//
//class errorMSGState extends State<errorMSG> {
//
//  Widget build(BuildContext context) => new Scaffold(
//    body: Container(
//      color: Colors.amberAccent,
//      width: double.infinity,
//      padding: EdgeInsets.all(8.0),
//      child: Row(
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.only(right: 8.0),
//            child: Icon(Icons.error_outline),
//          ),
//          Expanded(
//            child: AutoSizeText(
//              warning,
//              maxLines: 3,
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(left: 8.0),
//            child: IconButton(
//              icon: Icon(Icons.close),
//              onPressed: () {
//                setState(() {
//                  warning = null;
//                });
//              },
//            ),
//          )
//        ],
//      ),
//    )
//  );
//}