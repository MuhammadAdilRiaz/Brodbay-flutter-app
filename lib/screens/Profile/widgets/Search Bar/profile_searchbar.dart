import 'package:flutter/material.dart';

class ProfileSearchbar extends StatelessWidget {
  const ProfileSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        Row(
          children: [
            Expanded(
              child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: BoxBorder.all(color: Colors.black12)
                  ),
                  child: Row(
                    children:  [
                     const Icon(Icons.camera_alt_rounded, size: 20,),
                     const SizedBox(width: 10),
                     const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search Now",
                            border: InputBorder.none,
                            isDense: true, 
                          ),
                        ),
                      ),
                     
                         Icon(Icons.search,
                        color: Colors.black,
                        size: 18,),
                      
                    ],
                  ),
                
                    
                  ),
            ),
          ],
        );
  }
}
