import 'package:flutter/material.dart';

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  String _numeroTarjeta = '';
  String _fechaExpiracion = '';
  String _cvv = '';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Pago'),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Color.fromARGB(255, 36, 70, 36),
                    Color.fromARGB(179, 22, 24, 23),
                  ]
                : [
                    Color.fromARGB(255, 123, 153, 114),
                    Color.fromARGB(0, 191, 255, 191),
                  ],
            begin: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/previews/009/384/393/non_2x/credit-card-clipart-design-illustration-free-png.png',
                    fit: BoxFit.contain,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Número de Tarjeta'),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el número de su tarjeta';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingrese un número de tarjeta válido';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _numeroTarjeta = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Fecha de Expiración (MM/YY)'),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de expiración';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingrese una fecha de expiración válida';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _fechaExpiracion = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CVV'),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el CVV';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingrese un CVV válido';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _cvv = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Formulario válido, procesar el pago
                        // Agrega tu lógica de procesamiento de pago aquí
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Pago Exitoso'),
                            content: Text(
                              '¡Gracias por su compra! Su pedido será entregado en un plazo máximo de tres días.',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text('Finalizar Compra'),
                    style: ElevatedButton.styleFrom(
                      primary: isDarkMode ? Colors.grey[800] : Color.fromARGB(255, 14, 73, 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
