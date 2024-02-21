import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Pages/sing_in.dart';

import 'package:mi_app_optativa/src/Widgets/icon_container.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _usernameController = TextEditingController();

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
                  url: '../images/oso.png',
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
                      errorText: _usernameController.text.isEmpty
                          ? 'Username is required'
                          : null,
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
                            return 4; // Elevación cuando el botón está resaltado
                          }
                          return 2; // Elevación predeterminada
                        },
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(146, 105, 240, 175)),
                    ),
                    onPressed: () {
                      final route = MaterialPageRoute(
                        builder: (context) =>
                            SingIn(username: _usernameController.text),
                      );
                      Navigator.push(context, route);
                    },
                    child: Text(
                      'Sing In',
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
