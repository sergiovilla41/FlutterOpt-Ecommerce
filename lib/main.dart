import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';
import 'package:mi_app_optativa/src/Pages/AvatarPickerPage.dart';
import 'package:mi_app_optativa/src/Pages/Log_In.dart';
import 'package:mi_app_optativa/src/Pages/Joyeria.dart';
import 'package:mi_app_optativa/src/Pages/RopaParaCaballero.dart';
import 'package:mi_app_optativa/src/Pages/Home.dart';
import 'package:mi_app_optativa/src/Pages/RopaParaDama.dart';
import 'package:mi_app_optativa/src/Pages/Tecnologia.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          AvatarProvider(), // Aquí es donde crearás tu clase de proveedor
      child: LoginApp(),
    ),
  );
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
      initialRoute: 'LogIn',
      // Mapeo de rutas de la aplicación con los constructores de los widgets correspondientes
      routes: <String, WidgetBuilder>{
        // Ruta para la página de inicio
        'LogIn': (BuildContext context) => LogIn(),
        // Ruta para la página de inicio de sesión
        'Home': (BuildContext context) => Home(
              username: '',
              password: '',
            ),
        // Ruta para la página de tecnología
        'Tecnología': (BuildContext context) => tecnologia(),
        // Ruta para la página de joyería
        'Joyería': (BuildContext context) => joyeria(),
        // Ruta para la página de ropa para caballero
        'RopaCaballero': (BuildContext context) => RopaCaballero(),
        'RopaDama': (BuildContext context) => RopaDama(),
        'AvatarPickerPage': (BuildContext context) => AvatarPickerPage(),
      },
    );
  }
}
