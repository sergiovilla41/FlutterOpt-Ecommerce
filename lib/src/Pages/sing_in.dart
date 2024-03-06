import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mi_app_optativa/src/Pages/joyeria.dart';
import 'package:mi_app_optativa/src/Pages/ropa.dart';
import 'package:mi_app_optativa/src/Pages/tecnologia.dart';

void main() {
  runApp(MaterialApp(
    home: SingIn(
      username: 'Usuario', // Nombre de usuario predeterminado
      password: '', // Contraseña predeterminada
    ),
  ));
}

class SingIn extends StatefulWidget {
  final String username; // Nombre de usuario

  SingIn({Key? key, required this.username, required String password})
      : super(key: key);

  @override
  _SingInState createState() =>
      _SingInState(); // Crea el estado del widget SingIn
}

class _SingInState extends State<SingIn> {
  List<Product> products = []; // Lista de productos
  bool isDarkMode = false; // Variable para controlar el modo oscuro

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Llama a la función para cargar los productos al iniciar la aplicación
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://fakestoreapi.com/products')); // Realiza una solicitud HTTP para obtener los productos
    if (response.statusCode == 200) {
      setState(() {
        products = (json.decode(response.body) as List)
            .map((data) => Product.fromJson(data))
            .toList(); // Actualiza el estado de la aplicación con los productos obtenidos
      });
    } else {
      throw Exception(
          'Failed to load products'); // Lanza una excepción si no se pueden cargar los productos
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode
          ? ThemeData.dark()
          : ThemeData
              .light(), // Define el tema de la aplicación según el modo seleccionado
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'User: ${widget.username}', // Muestra el nombre de usuario en el AppBar
            style: TextStyle(
              fontFamily: 'FredokaOne',
              fontSize: 20,
              color: isDarkMode
                  ? Colors.white
                  : Colors.black, // Color del texto del AppBar
            ),
          ),
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 61, 60, 60)
              : Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
          actions: [
            CustomPopupMenuButton(
                isDarkMode: isDarkMode), // Muestra el menú desplegable
            IconButton(
              onPressed: () {
                // Acción al presionar el icono del carrito
              },
              icon: Icon(
                Icons.shopping_cart, // Icono del carrito de compras
                color:
                    isDarkMode ? Colors.white : Colors.black, // Color del icono
              ),
            ),
            SizedBox(width: 8), // Espacio adicional entre los iconos
            IconButton(
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode; // Cambia el estado del modo oscuro
                });
              },
              icon: Icon(
                isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode, // Icono según el modo seleccionado
                color: isDarkMode
                    ? Color.fromARGB(255, 236, 234, 234)
                    : Color.fromARGB(255, 175, 167, 54), // Color del icono
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Color.fromARGB(255, 9, 73, 36),
                      Color.fromARGB(179, 22, 24, 23),
                    ]
                  : [
                      Color.fromARGB(255, 230, 255, 230),
                      Color.fromARGB(0, 191, 255, 191),
                    ],
              begin: Alignment.topCenter,
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Store', // Agregar "Store" encima de las tarjetas
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 30,
                  color: isDarkMode
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = products[index];
                    return ProductCard(
                        product: product,
                        isDarkMode:
                            isDarkMode); // Construye la tarjeta de producto
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final int id; // ID del producto
  final String title; // Título del producto
  final double price; // Precio del producto
  final String image; // URL de la imagen del producto
  int quantity; // Cantidad de productos

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 0, // Inicializa la cantidad de productos en 0
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isDarkMode;

  const ProductCard({Key? key, required this.product, required this.isDarkMode})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                widget.product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: TextStyle(
                      fontFamily: 'FredokaOne',
                      fontSize: 16,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'FredokaOne',
                      fontSize: 16,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (widget.product.quantity > 0) {
                              widget.product.quantity--;
                            }
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text(
                        widget.product.quantity.toString(),
                        style: TextStyle(
                          fontFamily: 'FredokaOne',
                          fontSize: 16,
                          color: widget.isDarkMode
                              ? Color.fromARGB(255, 233, 229, 229)
                              : Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.product.quantity++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isButtonPressed =
                            !_isButtonPressed; // Cambia el estado del botón
                      });
                      // Agregar lógica para agregar al carrito
                    },
                    child: Text(
                      'Agregar +',
                      style: TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: 16,
                        color: _isButtonPressed
                            ? Color.fromARGB(255, 0, 0, 0)
                            : widget.isDarkMode
                                ? Color.fromARGB(255, 255, 255, 254)
                                : Color.fromARGB(255, 44, 44,
                                    44), // Color del texto siempre blanco
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: _isButtonPressed
                          ? Color.fromARGB(255, 44, 116, 47).withOpacity(0.8)
                          : widget.isDarkMode
                              ? const Color.fromARGB(255, 53, 87, 54)
                              : Color.fromARGB(255, 99, 151, 102),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPopupMenuButton extends StatelessWidget {
  final bool isDarkMode;

  const CustomPopupMenuButton({Key? key, required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case 'joyeria':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => joyeria()),
            );
            break;
          case 'tecnologia':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => tecnologia()),
            );
            break;
          case 'ropa':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ropa()),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'joyeria',
          child: Text(
            'Joyería',
            style: TextStyle(
              fontFamily: 'FredokaOne',
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'tecnologia',
          child: Text(
            'Tecnología',
            style: TextStyle(
              fontFamily: 'FredokaOne',
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'ropa',
          child: Text(
            'Ropa',
            style: TextStyle(
              fontFamily: 'FredokaOne',
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Menú',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 20,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Icon(Icons.arrow_drop_down,
              color: isDarkMode ? Colors.white : Colors.black),
        ],
      ),
    );
  }
}

class JewelryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joyería'), // Título de la página
      ),
      body: Center(
        child: Text('Página de Joyería'), // Contenido de la página
      ),
    );
  }
}

class TechnologyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tecnología'), // Título de la página
      ),
      body: Center(
        child: Text('Página de Tecnología'), // Contenido de la página
      ),
    );
  }
}

class ClothingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ropa'), // Título de la página
      ),
      body: Center(
        child: Text('Página de Ropa'), // Contenido de la página
      ),
    );
  }
}
