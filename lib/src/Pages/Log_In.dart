import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Models/Usuarios.dart';
import 'package:mi_app_optativa/src/Pages/Home.dart';
import 'package:mi_app_optativa/src/Service/LoginService.dart';
import 'package:mi_app_optativa/src/Widgets/icon_container.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  UserService _userService =
      UserService(); // Instancia del servicio UserService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromARGB(255, 9, 73, 36),
              Color.fromARGB(0, 80, 239, 191),
            ],
            begin: Alignment.topCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 200),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconContainer(
                  url: 'images/oso.png',
                ),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 38.0,
                  ),
                ),
                Divider(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return 4;
                          }
                          return 2;
                        },
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(146, 105, 240, 175)),
                    ),
                    onPressed: () async {
                      // Obtiene la lista de usuarios
                      List<User> users = await _userService.fetchUsers();
                      // Valida las credenciales ingresadas por el usuario
                      bool validCredentials = false;
                      for (User user in users) {
                        if (user.username == _usernameController.text &&
                            user.password == _passwordController.text) {
                          validCredentials = true;
                          break;
                        }
                      }
                      if (validCredentials) {
                        final route = MaterialPageRoute(
                          builder: (context) => Home(
                              username: _usernameController.text,
                              password: _passwordController.text),
                        );
                        Navigator.push(context, route);
                      } else {
                        // Muestra una ventana emergente de "acceso denegado"
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Access Denied',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 56, 83, 30),
                                  fontFamily: 'FredokaOne',
                                  fontSize: 20.0,
                                ),
                              ),
                              content: Text(
                                'Invalid username or password',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 56, 83, 30),
                                  fontFamily: 'FredokaOne',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 56, 83, 30),
                                      fontFamily: 'FredokaOne',
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
