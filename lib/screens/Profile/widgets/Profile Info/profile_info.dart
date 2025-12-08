import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hello", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
              Row(
                children: [
                  Icon(Icons.settings, size: 20),
                  SizedBox(width: 12),
                  Icon(Icons.flag_outlined, size: 20)
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 10),
         Center(
           child: Text("Sign in for the best\n experience",
           textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
         ),
         SizedBox(height: 40,)
      ],

    );
  }
}