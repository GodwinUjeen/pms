import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pms/HelpersClass/Helpers.dart';

import 'package:pms/Services/Authentication.dart';
import 'package:pms/Services/FirebaseOperations.dart';
import 'package:pms/SplashScreen/SplashScreen.dart';
import 'package:pms/Staff/Helpers/StaffHomePageHelpers.dart';
import 'package:pms/Student/Screens/Helpers/HomePageHelpers.dart';
import 'package:pms/models/Model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StaffHomePageHelpers()),
        ChangeNotifierProvider(create: (_) => HomePageHelpers()),
        ChangeNotifierProvider(create: (_) => Helpers()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(
          create: (_) => FirebaseOperations(),
        ),
      ],
      child: StreamProvider<FUser>.value(
        initialData: null,
        value: Authentication().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primarySwatch: Colors.amber,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
