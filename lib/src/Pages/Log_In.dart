import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Pages/Home.dart';
import 'package:mi_app_optativa/src/Widgets/icon_container.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromARGB(255, 11, 90, 128),
              Color.fromARGB(108, 28, 65, 167),
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
                  'Galeria Flutter',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 38.0,
                    color: const Color.fromARGB(255, 226, 236, 245),
                  ),
                ),
                Divider(
                  height: 20.0,
                ),
                SizedBox(
                  height: 20.0,
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
                          Color.fromARGB(234, 43, 106, 179)),
                    ),
                    onPressed: () {
                      final route = MaterialPageRoute(
                        builder: (context) => Home(),
                      );
                      Navigator.push(context, route);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
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
