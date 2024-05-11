import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';
import 'package:mi_app_optativa/src/Widgets/avatar_widget.dart';
import 'package:provider/provider.dart';

class ContactFormWidget extends StatefulWidget {
  @override
  _ContactFormWidgetState createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isDarkMode = false;
  String _selectedDocumentType = 'NIT';
  String _selectedRequestType = 'Reclamación';
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final selectedAvatar = Provider.of<AvatarProvider>(context).selectedAvatar;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = isDarkMode
        ? Color.fromARGB(255, 30, 63, 40)
        : Color.fromARGB(255, 5, 124, 35);
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  right: 2), // Ajusta el margen derecho según sea necesario
              child: Text(
                ' Contactanos',
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 22,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            AvatarWidget(
              avatar: selectedAvatar,
              onSelectAvatar: (avatar) {
                Provider.of<AvatarProvider>(context, listen: false)
                    .setSelectedAvatar(avatar);
              },
            ),
          ],
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
        leading: IconButton(
          // Aquí está el IconButton para la flecha hacia atrás
          icon: Icon(
            Icons.arrow_back, // Icono de flecha hacia atrás
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(
                context); // Esto hará que la pantalla retroceda cuando se presione el botón de flecha hacia atrás
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Color.fromARGB(255, 36, 70, 36),
                    Color.fromARGB(179, 22, 24, 23)
                  ]
                : [
                    Color.fromARGB(255, 123, 153, 114),
                    Color.fromARGB(0, 191, 255, 191)
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter, // Extremo inferior
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              // Cambio aquí
              children: <Widget>[
                // También puedes probar a envolver los elementos en un Column, según tus necesidades
                TextFormField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDocumentType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedDocumentType = value!;
                    });
                  },
                  items: <String>['NIT', 'PB', 'RC', 'CC', 'CE']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Tipo de Documento',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRequestType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRequestType = value!;
                    });
                  },
                  items: <String>[
                    'Reclamación',
                    'Devolución',
                    'Cambio',
                    'Opinión',
                    'Otro'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Tipo de Solicitud',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Calificar Servicio:',
                      style: TextStyle(color: textColor),
                    ),
                    SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.yellow,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  child: Container(
                    // Envuelve el texto del botón en un contenedor
                    width: double.infinity, // Ancho máximo disponible
                    height: 50, // Altura del botón
                    alignment: Alignment
                        .center, // Centra el texto del botón verticalmente
                    child: Text('Enviar',
                        style: TextStyle(
                            fontSize: 18)), // Establece el tamaño del texto
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    onPrimary: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('¡Formulario Enviado!'),
          content: Text(
              'Su solicitud ha sido enviada y será atendida por un asesor en menos de 2 horas.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
