import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_app_optativa/src/Pages/ropa.dart';
import 'dart:convert';

import 'package:mi_app_optativa/src/Pages/tecnologia.dart';

void main() {
  runApp(MaterialApp(
    home: joyeria(),
  ));
}

class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    this.quantity = 0,
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

class joyeria extends StatefulWidget {
  @override
  _joyeriaState createState() => _joyeriaState();
}

class _joyeriaState extends State<joyeria> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/category/jewelery'));
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Joyería',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9), //
        actions: [
          CustomPopupMenuButton(isDarkMode: isDarkMode),
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
                  return ProductCard(product: product, isDarkMode: isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
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
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 130,
              child: Image.network(
                widget.product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Text(
              widget.product.title,
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 16,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 16,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (quantity > 0) {
                      quantity--;
                    }
                  });
                },
                icon: Icon(Icons.remove),
              ),
              Text(
                quantity.toString(),
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                icon: Icon(Icons.add),
              ),
              ElevatedButton(
                onPressed: () {
                  addToCart(widget.product, quantity, context);
                },
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 16,
                    color: widget.isDarkMode
                        ? Color.fromARGB(255, 255, 255, 254)
                        : Color.fromARGB(255, 44, 44, 44),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: widget.isDarkMode
                      ? const Color.fromARGB(255, 53, 87, 54)
                      : Color.fromARGB(255, 99, 151, 102),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addToCart(Product product, int quantity, BuildContext context) {
    product.quantity += quantity;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Agregado al carrito: ${product.title} x $quantity'),
      duration: Duration(seconds: 2),
    ));
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
        // Añadir más elementos de menú para otras categorías si es necesario
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
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
