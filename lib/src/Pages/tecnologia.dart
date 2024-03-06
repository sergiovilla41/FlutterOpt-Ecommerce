import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mi_app_optativa/src/Pages/joyeria.dart';
import 'package:mi_app_optativa/src/Pages/ropa.dart';

void main() {
  runApp(MaterialApp(
    home: tecnologia(),
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

class tecnologia extends StatefulWidget {
  const tecnologia({super.key});

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
        actions: [
          CustomPopupMenuButton(
              isDarkMode: isDarkMode), // Muestra el menú desplegable
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShoppingCartPage(products: products)),
          );
        },
        child: Icon(Icons.shopping_cart),
        backgroundColor: const Color.fromARGB(255, 58, 100, 59),
        foregroundColor: isDarkMode
            ? Colors.white
            : Colors.black, // Color de fondo del botón
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

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 130, // Altura fija de la tarjeta
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
                fontSize: 14, // Ajusta el tamaño del texto
                color:
                    isDarkMode ? Colors.white : Color.fromARGB(255, 10, 10, 10),
              ),
            ),
            subtitle: Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 14, // Ajusta el tamaño del texto
                color:
                    isDarkMode ? Colors.white : Color.fromARGB(255, 15, 15, 15),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
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
                quantity.toString(), // Muestra la cantidad actual
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 14, // Ajusta el tamaño del texto
                  color: isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 18, 19, 18),
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
                  addToCart(widget.product, quantity);
                },
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 16,
                    color: isDarkMode
                        ? Color.fromARGB(255, 255, 255, 254)
                        : Color.fromARGB(255, 44, 44, 44),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: isDarkMode
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

  void addToCart(Product product, int quantity) {
    product.quantity += quantity;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Agregado al carrito: ${product.title} x $quantity'),
      duration: Duration(seconds: 1),
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
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class ShoppingCartPage extends StatelessWidget {
  final List<Product> products;

  const ShoppingCartPage({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = 0;

    // Calcular el total del carrito
    for (var product in products) {
      total += product.price * product.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de compras'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text('Cantidad: ${product.quantity}'),
            trailing: Text(
                '\$${(product.price * product.quantity).toStringAsFixed(2)}'),
            onTap: () {
              // Acción al hacer clic en un producto (opcional)
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
