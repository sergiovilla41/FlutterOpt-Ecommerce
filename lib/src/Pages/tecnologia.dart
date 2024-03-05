import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_app_optativa/src/Pages/joyeria.dart';
import 'dart:convert';

import 'package:mi_app_optativa/src/Pages/ropa.dart';

class tecnologia extends StatefulWidget {
  tecnologia({Key? key}) : super(key: key);

  @override
  _tecnologiaState createState() => _tecnologiaState();
}

class _tecnologiaState extends State<tecnologia> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products/category/electronics'));
    if (response.statusCode == 200) {
      setState(() {
        products = (json.decode(response.body) as List)
            .map((data) => Product.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Tecnología',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: Colors.white, // Color del texto del AppBar
          ),
        ),
        backgroundColor:
            Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
        actions: [
          CustomPopupMenuButton(), // Muestra el menú desplegable
          IconButton(
            onPressed: () {
              // Acción al presionar el icono del carrito
            },
            icon: Icon(
              Icons.shopping_cart, // Icono del carrito de compras
              color: Colors.white, // Color del icono
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromARGB(255, 9, 73, 36),
              Color.fromARGB(0, 80, 239, 191),
            ],
            begin: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store:',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 20,
                color: Color.fromARGB(255, 225, 228, 226),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      category: json['category'],
      image: json['image'],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              product.image,
              width: 60, // Ajusta el tamaño de la imagen
              height: 60, // Ajusta el tamaño de la imagen
              fit: BoxFit.cover,
            ),
            title: Text(
              product.title,
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 14, // Ajusta el tamaño del texto
                color: Color.fromARGB(255, 9, 73, 36),
              ),
            ),
            subtitle: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 14, // Ajusta el tamaño del texto
                color: Color.fromARGB(255, 9, 73, 36),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
            children: [
              IconButton(
                onPressed: () {
                  // Acción para restar la cantidad
                },
                icon: Icon(Icons.remove),
              ),
              Text(
                '0',
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 14, // Ajusta el tamaño del texto
                  color: Color.fromARGB(255, 9, 73, 36),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Acción para sumar la cantidad
                },
                icon: Icon(Icons.add),
              ),
              ElevatedButton(
                onPressed: () {
                  // Acción para agregar al carrito
                },
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 9, 73, 36),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomPopupMenuButton extends StatelessWidget {
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
              color: Color.fromARGB(255, 9, 73, 36),
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
              color: Color.fromARGB(255, 9, 73, 36),
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
              color: Color.fromARGB(255, 9, 73, 36),
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
                color: Color.fromARGB(255, 232, 235, 232),
              ),
            ),
          ),
          Icon(Icons.arrow_drop_down),
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

void main() {
  runApp(MaterialApp(
    home: tecnologia(),
  ));
}
