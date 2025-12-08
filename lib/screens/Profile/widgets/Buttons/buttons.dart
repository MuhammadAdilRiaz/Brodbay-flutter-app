import 'package:flutter/material.dart';

class Buttonswidget extends StatelessWidget {
   final VoidCallback? onAuthTap;
  const Buttonswidget({Key? key, this.onAuthTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              width: 300,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFB380),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
                 onPressed: onAuthTap,
                child: const Text(
                 'Sign in',
                style: TextStyle(color: Colors.white),
                         ),
                        ),
            ),
            const SizedBox(height: 6),

              SizedBox(
                width: 300,
                child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
              ),
                


          ] 
                        
        ),
      ],
    );
    }
}