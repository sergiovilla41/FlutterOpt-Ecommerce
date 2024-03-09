import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_app_optativa/src/Pages/home_page.dart';
import 'package:mi_app_optativa/src/Pages/joyeria.dart';
import 'package:mi_app_optativa/src/Pages/ropa.dart';
import 'package:mi_app_optativa/src/Pages/sing_in.dart';
import 'package:mi_app_optativa/src/Pages/tecnologia.dart';

void main() {
  // Inicia la aplicación llamando al widget LoginApp
  runApp(LoginApp());
}

// Widget principal que representa la aplicación de inicio de sesión
class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Establece las orientaciones preferidas del dispositivo como vertical
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // Retorna un MaterialApp, que es la raíz de la aplicación
    return MaterialApp(
      // Título de la aplicación
      title: 'Login App',
      // Tema de la aplicación
      theme: ThemeData(
        // Color primario de la aplicación
        primaryColor: Color.fromARGB(255, 43, 82, 38),
        // Color de pista para los campos de entrada
        hintColor: Color.fromARGB(255, 67, 105, 34),
        // Densidad visual adaptativa
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ), // Cambia el color aquí
        ),
      ),
      // Ruta inicial de la aplicación
      initialRoute: 'Home',
      // Mapeo de rutas de la aplicación con los constructores de los widgets correspondientes
      routes: <String, WidgetBuilder>{
        // Ruta para la página de inicio
        'Home': (BuildContext context) => HomePage(),
        // Ruta para la página de inicio de sesión
        'SingIn': (BuildContext context) => SignIn(
              username: '',
              password: '',
            ),
        // Ruta para la página de tecnología
        'Tecnología': (BuildContext context) => tecnologia(),
        // Ruta para la página de joyería
        'Joyería': (BuildContext context) => joyeria(),
        // Ruta para la página de ropa
        'Ropa': (BuildContext context) => ropa(),
      },
    );
  }
}
