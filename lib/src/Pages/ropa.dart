import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: ropa(),
  ));
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.quantity = 0,
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

class ropa extends StatefulWidget {
  @override
  _ropaState createState() => _ropaState();
}

class _ropaState extends State<ropa> {
  List<Product> products = [];
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://fakestoreapi.com/products/category/men%27s%20clothing'));
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
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Ropa',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9),
        actions: [
          CustomPopupMenuButton(isDarkMode: isDarkMode),
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
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
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
                  addToCart(widget.product, quantity);
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

  void addToCart(Product product, int quantity) {
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
              MaterialPageRoute(builder: (context) => JewelryPage()),
            );
            break;
          case 'tecnologia':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TechnologyPage()),
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
