import 'package:flutter/material.dart';
// height
const kHeight2 = SizedBox(height: 2);
const kHeight5 = SizedBox(height: 5);
const kHeight10 = SizedBox(height: 10);
const kHeight15 = SizedBox(height: 15);
const kHeight20 = SizedBox(height: 20);
const kHeight25 = SizedBox(height: 25);
const kHeight30 = SizedBox(height: 30);
const kHeight35 = SizedBox(height: 35);
const kHeight40 = SizedBox(height: 40);
const kHeight45 = SizedBox(height: 45);
const kHeight50 = SizedBox(height: 50);
// width
const kWidth2 = SizedBox(width:  2);
const kWidth5 = SizedBox(width:  5);
const kWidth10 = SizedBox(width:  10);
const kWidth15 = SizedBox(width:  15);
const kWidth20 = SizedBox(width:  20);
const kWidth25 = SizedBox(width:  25);
const kWidth30 = SizedBox(width:  30);
const kWidth35 = SizedBox(width:  35);
const kWidth40 = SizedBox(width:  40);
const kWidth45 = SizedBox(width:  45);
const kWidth50 = SizedBox(width:  50);


const zeroMeasuredWidget = SizedBox(height: 0,width: 0);
double screenWidth({required BuildContext context}){
  return MediaQuery.of(context).size.width;
}
double screenHeight({required BuildContext context}){
  return MediaQuery.of(context).size.height;
}