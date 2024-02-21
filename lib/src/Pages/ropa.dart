import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ropa extends StatefulWidget {
  ropa({Key? key}) : super(key: key);

  @override
  _ropaState createState() => _ropaState();
}

class _ropaState extends State<ropa> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://fakestoreapi.com/products/category/men\'s clothing'));
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
          ' Ropa',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: Colors.white, // Color del texto del AppBar
          ),
        ),
        backgroundColor:
            Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
        actions: [
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

void main() {
  runApp(MaterialApp(
    home: ropa(),
  ));
}
