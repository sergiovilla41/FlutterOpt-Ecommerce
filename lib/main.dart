import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_app_optativa/src/Pages/home_page.dart';
import 'package:mi_app_optativa/src/Pages/sing_in.dart';
import 'package:mi_app_optativa/src/Pages/sing_up.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 43, 82, 38),
        hintColor: Color.fromARGB(255, 67, 105, 34),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'Home',
      routes: <String, WidgetBuilder>{
        'Home': (BuildContext context) => HomePage(),
        'Sing In': (BuildContext context) => SingIn(),
        'Sing Up': (BuildContext context) => SingUp(),
      },
    );
  }
}
