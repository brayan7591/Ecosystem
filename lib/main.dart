import 'package:flutter/material.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/paginas/pagina_inicio.dart';
import 'firebase_options.dart';

import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}
//stls
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'firebase Demo',
      home: Splash(),
    );
  }
}


class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('img/recycle.json'), 
      nextScreen: EcoSystemApp(),
      duration: 4000,
      splashIconSize: 600,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: Duration(seconds: 2),
      );
  }
}
