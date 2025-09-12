import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor =const Color(0xFFC65C38),
  required Function function,
  double radius = 20,
  required String text,
  bool isUppercase = true,
  IconData? icon,
  double? iconSize,
  Color? iconColor,
  bool icons = false,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: backgroundColor,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: iconColor,size: iconSize,),
            icons ?const SizedBox(width: 30):const SizedBox(width: 0,),
            Text(
              isUppercase ? text.toUpperCase() : text,
              style:const TextStyle(color: Colors.white,
              fontSize: 20
              ),
            ),


          ],
        ),
      ),
    );

Widget myDivider() => Padding(
  padding:  EdgeInsets.symmetric(horizontal:10 ),
  child:   Container(
    width: double.infinity,
    height: 1,
    color: Colors.blue,
  ),
);

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: choseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { success, error, warning }

Color choseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}


