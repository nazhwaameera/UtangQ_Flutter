import 'package:flutter/material.dart';

class SquareCardMenu extends StatelessWidget {
  final IconData icon;
  final String description;
  final Function()? onTap;
  final Color iconColor; // New property for custom icon color

  const SquareCardMenu({
    Key? key,
    required this.icon,
    required this.description,
    this.onTap,
    this.iconColor = Colors.blue, // Default icon color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Adjust height as needed
        margin: EdgeInsets.all(10), // Adjust spacing as needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: iconColor, // Use custom icon color
            ),
            SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

