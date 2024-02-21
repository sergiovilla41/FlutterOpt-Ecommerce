import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SingIn extends StatefulWidget {
  final String username; // Añade esta línea

  SingIn({Key? key, required this.username})
      : super(key: key); // Modifica el constructor

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
          'Bienvenido: ${widget.username}!', // Usa el nombre de usuario aquí
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: Color.fromARGB(255, 9, 73, 36),
          ),
        ),
        actions: [
          CustomPopupMenuButton(),
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
              'Productos:',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 20,
                color: Color.fromARGB(255, 9, 73, 36),
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
          child: Text('Comprar'),
        ),
      ),
    );
  }
}

class CustomPopupMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
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
                color: Color.fromARGB(255, 9, 73, 36),
              ),
            ),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
