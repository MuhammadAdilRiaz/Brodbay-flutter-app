
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF6304),
            Color(0xFFFF7D26),
            Color(0xFFFF944D),
            Color(0xFFFFB380),
            Color(0xFFFFD1B3),
            Color.fromARGB(255, 224, 211, 248),
            Color.fromARGB(255, 255, 255, 255),
          ],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter)
      ),
    );
  }
}