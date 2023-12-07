import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Variants { success, error }

class ToastUtil {
  showCustom(BuildContext context, String? text, Variants? variants) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      margin: const EdgeInsets.only(
          top: 30), // Add margin to give space from the top
      padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 12), // Increase padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            25), // Increase BorderRadius for a more rounded appearance
        color: variants == Variants.error ? Colors.red : Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Change to min to wrap content
        children: [
          Icon(
            variants == Variants.error ? Icons.close : Icons.check,
            color: Colors.white,
            size: 20, // Adjust icon size if needed
          ),
          SizedBox(width: 12),
          Text(
            text!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, // Adjust font size
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.TOP, // Ensure the toast sticks to the top
    );
  }
}
