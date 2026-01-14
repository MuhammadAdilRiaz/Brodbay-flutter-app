import 'package:brodbay/models/product%20model/product_hive.dart';
import 'package:brodbay/providers/profile%20provider/profile_providers.dart';
import 'package:brodbay/screens/splash%20screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'widgets/Bottom Bar/bottom_nav_bar.dart';
import 'firebase_options.dart';


void main() 
 async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HiveProductAdapter());

  await Hive.openBox<HiveProduct>('productsBox');
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  runApp(
     ProviderScope(
       child: MultiProvider(
        providers: [
           ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
          child:  const MyApp()),
     ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // ✅ START HERE
      routes: {
        '/home': (_) => BottomNavBar(),
      },
    );
  }
}