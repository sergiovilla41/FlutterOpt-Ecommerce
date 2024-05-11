import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Pages/ContactanosPage.dart';

class ContactButton extends StatelessWidget {
  final Color buttonColor; // Color del botón flotante
  final Color iconColor; // Color del icono

  const ContactButton(
      {Key? key, required this.buttonColor, required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'contactButton', // Asigna un identificador único
      backgroundColor: buttonColor, // Establece el color del botón flotante
      child: Icon(Icons.supervisor_account, color: iconColor),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactFormWidget(),
          ),
        );
      },
    );
  }
}
