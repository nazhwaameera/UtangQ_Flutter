import 'package:flutter/material.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';

void showSimpleModalDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          constraints: BoxConstraints(maxHeight: 150),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 40.0, 20.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: message,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                      wordSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300]
                      ),
                      child: Text('Close', style:TextStyle(
                        color: Colors.grey[700]
                      )),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700]
                      ),
                      child: Text('OK', style: TextStyle(
                        color: Colors.red[100]
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
