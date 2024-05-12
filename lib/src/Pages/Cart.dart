import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';
import 'package:mi_app_optativa/src/Controllers/CarritoComprasController.dart';
import 'package:mi_app_optativa/src/Models/product.dart';
import 'package:mi_app_optativa/src/Widgets/avatar_widget.dart';
import 'package:provider/provider.dart';
import 'package:mi_app_optativa/src/Widgets/pago.dart';

class ShoppingCartPage extends StatefulWidget {
  final List<Product> products;
  final bool isDarkMode;

  final Function(int) updateCartItemCount; // Nueva función de callback
  const ShoppingCartPage({
    Key? key,
    required this.products,
    required this.isDarkMode,
    required this.updateCartItemCount, // Actualizado para recibir la función de callback
  }) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Product> get _cartItems => CartController.getCartItems();
  double _calculateTotal() {
    double total = 0;
    for (var product in widget.products) {
      total += product.price * product.quantity;
    }
    return total;
  }

  void _updateCartItemCount() {
    // Actualiza la lista de productos en el carrito
    // _cartItems.clear();
    _cartItems.addAll(CartController.getCartItems());

    // Recalcula la cantidad total de productos en el carrito
    int totalItems =
        _cartItems.fold(0, (sum, product) => sum + product.quantity);
    widget.updateCartItemCount(totalItems);
  }

  @override
  Widget build(BuildContext context) {
    final selectedAvatar = Provider.of<AvatarProvider>(context).selectedAvatar;
    bool isOpen = false;
    return Scaffold(floatingActionButton:
        FilledButton(
          onPressed: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Text(
            'Pagar',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Shopping Cart',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 20,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            AvatarWidget(
              avatar: selectedAvatar,
              onSelectAvatar: (avatar) {
                Provider.of<AvatarProvider>(context, listen: false)
                    .setSelectedAvatar(avatar);
              },
            ),
          ],
        ),
        backgroundColor: widget.isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : const Color.fromARGB(207, 14, 73, 9),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildShoppingCartList(),
      bottomNavigationBar: BottomAppBar(
          child: //Row(children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          color: widget.isDarkMode
              ? const Color.fromARGB(255, 61, 60, 60)
              : const Color.fromARGB(207, 14, 73, 9),
          child: Text(
            'Total: \$${_calculateTotal().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     setState(() {
        //       isOpen = !isOpen;
        //     });
        //   },
        //   child: Text(
        //     'Pagar',
        //     style: TextStyle(
        //       fontSize: 20.0,
        //       fontWeight: FontWeight.bold,
        //       color: widget.isDarkMode ? Colors.white : Colors.black,
        //     ),
        //   ),
        // ),
     // ])
      ),
    );
  }

  Widget _buildShoppingCartList() {
    List<Product> filteredProducts = CartController.getCartItems()
        .where((product) => product.quantity > 0)
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
                  const Color.fromARGB(255, 36, 70, 36),
                  const Color.fromARGB(179, 22, 24, 23),
                ]
              : [
                  const Color.fromARGB(255, 123, 153, 114),
                  const Color.fromARGB(0, 191, 255, 191),
                ],
          begin: Alignment.topCenter,
        ),
      ),
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final productTotalPrice = product.price * product.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(3), // Aplica un borde redondeado
            color: const Color.fromARGB(85, 224, 224,
                224), // Color de fondo para cuando la imagen está cargando
          ),
          child: Center(
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
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
                        CartController.decrementQuantity(product);
                        CartController.removeProduct(product);
                      }
                    });
                  },
                  icon: Icon(Icons.remove),
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
                Text(
                  '${product.quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      CartController.incrementQuantity(product);
                    });
                  },
                  icon: Icon(Icons.add),
                  color: widget.isDarkMode ? Colors.white : Colors.black,
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
              product.quantity = 0;
              CartController.removeProduct(product);
              _updateCartItemCount();
            });
          },
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
