import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_app_optativa/src/Pages/joyeria.dart';
import 'package:mi_app_optativa/src/Pages/ropa.dart';
import 'dart:convert';

import 'package:mi_app_optativa/src/Pages/tecnologia.dart';

class SingIn extends StatefulWidget {
  final String username;

  SingIn({Key? key, required this.username, required String password})
      : super(key: key);

  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
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
          'User: ${widget.username}',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: Color.fromARGB(
                255, 232, 235, 232), // Color del texto del AppBar
          ),
        ),
        backgroundColor:
            Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
        actions: [
          CustomPopupMenuButton(),
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
              'Store', // Agregar "Store" encima de las tarjetas
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 30,
                color: Color.fromARGB(255, 238, 240, 239),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
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
      child: ListTile(
        leading: Image.network(
          product.image,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
        title: Text(
          product.title,
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 16,
            color: Color.fromARGB(255, 9, 73, 36),
          ),
        ),
        subtitle: Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 16,
            color: Color.fromARGB(255, 9, 73, 36),
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Acción para agregar al carrito
          },
          child: Text(
            'Comprar',
            style: TextStyle(
              color: Color.fromARGB(
                  255, 232, 235, 232), // Color del texto del botón
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 9, 73, 36), // Color de fondo del botón
          ),
        ),
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
        title: Text('Joyería'),
      ),
      body: Center(
        child: Text('Página de Joyería'),
      ),
    );
  }
}

class TechnologyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tecnología'),
      ),
      body: Center(
        child: Text('Página de Tecnología'),
      ),
    );
  }
}

class ClothingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ropa'),
      ),
      body: Center(
        child: Text('Página de Ropa'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SingIn(
      username: 'Usuario',
      password: '',
    ),
  ));
}
