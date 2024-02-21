import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Importa el widget de icono

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(
            255, 9, 73, 36), // Color de fondo de la barra de navegación
        hintColor:
            Color.fromARGB(146, 105, 240, 175), // Color de fondo del botón
        scaffoldBackgroundColor:
            Color.fromARGB(255, 9, 73, 36), // Color de fondo de la página
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: Color.fromARGB(255, 9, 73, 36), // Color de texto principal
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 9, 73, 36), // Color de texto secundario
          ),
          button: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 16,
            color: Colors.white, // Color de texto del botón
          ),
        ),
      ),
      home: SingIn(),
    );
  }
}

class SingIn extends StatefulWidget {
  SingIn({Key? key}) : super(key: key);

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
        title: Text('Store Optativa'),
        actions: [
          CustomPopupMenuButton(),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Acción para mostrar el carrito
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos:',
              style: Theme.of(context).textTheme.headline6,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Regresar a la pantalla de inicio (Home)
        },
        child: Icon(Icons.arrow_back),
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
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.subtitle1,
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
          child: Text('Joyería'),
        ),
        PopupMenuItem<String>(
          value: 'tecnologia',
          child: Text('Tecnología'),
        ),
        PopupMenuItem<String>(
          value: 'ropa',
          child: Text('Ropa'),
        ),
      ],
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Menú',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
