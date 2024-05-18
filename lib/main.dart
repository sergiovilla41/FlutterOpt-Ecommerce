import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_app_optativa/src/Pages/Home.dart';
import 'package:mi_app_optativa/src/Pages/Log_In.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AvatarProvider(),
      child: LoginApp(),
    ),
  );
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 43, 82, 38),
        hintColor: Color.fromARGB(255, 67, 105, 34),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'LogIn',
      routes: <String, WidgetBuilder>{
        'LogIn': (BuildContext context) => LogIn(),
        'Home': (BuildContext context) => Home(),
      },
    );
  }
}
