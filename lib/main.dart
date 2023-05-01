import '/routes.dart';
import '/screens/splash_screen/splash_screen.dart';
import '/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDFyRPKDbfJoJNNlldHvVG7hnH19HIlbws', // Your apiKey
      appId: '1:1064722378113:android:dabc4263bbf875de754c80', // Your appId
      messagingSenderId: '1064722378113', // Your messagingSenderId
      projectId: 'edufy-76242', // Your projectId
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //it requires 3 parameters
    //context, orientation, device
    //it always requires, see plugin documentation
    return Sizer(builder: (context, orientation, device) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Edufy',
        theme: CustomTheme().baseTheme,
        //initial route is splash screen
        //mean first screen
        initialRoute: SplashScreen.routeName,
        //define the routes file here in order to access the routes any where all over the app
        routes: routes,
      );
    });
  }
}
