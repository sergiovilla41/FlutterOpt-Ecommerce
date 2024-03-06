import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Pages/sing_in.dart';

class ShoppingCartPage extends StatefulWidget {
  final List<Product> products;
  final bool isDarkMode; // Agregar el parámetro isDarkMode

  const ShoppingCartPage({
    Key? key,
    required this.products,
    required this.isDarkMode, // Agregar este parámetro
  }) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  double total = 0;

  @override
  void initState() {
    super.initState();
    // Calcular el total del carrito
    for (var product in widget.products) {
      total += product.price * product.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts =
        widget.products.where((product) => product.quantity > 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrito de compras',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 20,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: widget.isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode
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
        child: ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final productTotalPrice = product.price * product.quantity;
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
              child: ListTile(
                title: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Precio: \$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (product.quantity > 0) {
                                product.quantity--;
                                total -= product.price;
                              }
                            });
                          },
                          icon: Icon(Icons.remove),
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                        Text(
                          '${product.quantity}',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              product.quantity++;
                              total += product.price;
                            });
                          },
                          icon: Icon(Icons.add),
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                    Text(
                      'Total: \$${productTotalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      total -= productTotalPrice;
                      product.quantity = 0;
                    });
                  },
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        color: widget.isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9),
      ),
    );
  }
}
