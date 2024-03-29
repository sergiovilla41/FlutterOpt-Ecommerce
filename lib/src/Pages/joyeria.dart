import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_app_optativa/src/Pages/Cart.dart';
import 'package:mi_app_optativa/src/Pages/product.dart';
import 'package:mi_app_optativa/src/Pages/ropa.dart';
import 'package:mi_app_optativa/src/Pages/tecnologia.dart';

void main() {
  runApp(MaterialApp(
    home: joyeria(),
  ));
}

class joyeria extends StatefulWidget {
  @override
  _joyeriaState createState() => _joyeriaState();
}

class _joyeriaState extends State<joyeria> {
  List<Product> products = [];
  int totalUniqueProducts = 0;

  void updateTotalProducts() {
    int total = 0;
    for (var product in products) {
      total += product.quantity;
    }
    setState(() {
      totalUniqueProducts = total;
    });
  }

  Set<int> uniqueProductIds = {};

  void updateUniqueProductIds() {
    Set<int> uniqueIds = {};
    for (var product in products) {
      if (product.quantity > 0) {
        uniqueIds.add(product.id);
      }
    }
    setState(() {
      uniqueProductIds = uniqueIds;
    });
  }

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
    int totalUniqueProducts =
        uniqueProductIds.length; // Define totalUniqueProducts aquí

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Joyeria',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 30,
            color: isDarkMode ? Colors.white : Colors.black,
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
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCartPage(
                    products: products,
                    isDarkMode: isDarkMode,
                  ),
                ),
              );
            },
            child: Icon(Icons.shopping_cart),
            backgroundColor: const Color.fromARGB(255, 58, 100, 59),
            foregroundColor: isDarkMode ? Colors.white : Colors.black,
          ),
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                totalUniqueProducts.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store',
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
                    isDarkMode: isDarkMode,
                    updateTotalProducts: updateTotalProducts,
                    updateUniqueProductIds: updateUniqueProductIds,
                  );
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
  final VoidCallback updateTotalProducts;
  final VoidCallback updateUniqueProductIds;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isDarkMode,
    required this.updateTotalProducts,
    required this.updateUniqueProductIds,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
                    if (widget.product.quantity > 0) {
                      widget.product.quantity--;
                      widget.updateTotalProducts();
                      widget.updateUniqueProductIds();
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
                    widget.updateTotalProducts();
                    widget.updateUniqueProductIds();
                  });
                },
                icon: Icon(Icons.add),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  widget.product.quantity = widget.product.quantity == 0
                      ? 1
                      : widget.product.quantity;
                  widget.updateTotalProducts();
                  widget.updateUniqueProductIds();
                },
                child: Text(
                  'Agregar +',
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 16,
                    color: widget.isDarkMode
                        ? const Color.fromARGB(255, 252, 252, 252)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: widget.isDarkMode
                      ? Color.fromARGB(255, 53, 87, 54)
                      : Color.fromARGB(255, 99, 151, 102),
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
  final bool isDarkMode;
  const CustomPopupMenuButton({Key? key, required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case 'joyeria':
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
          Icon(
            Icons.arrow_drop_down,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}
