import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Models/product.dart';
import 'package:mi_app_optativa/src/Pages/Cart.dart';
import 'package:mi_app_optativa/src/Controllers/CarritoComprasController.dart';

class FloatingCartButton extends StatelessWidget {
  final List<Product> products;
  final bool isDarkMode;

  const FloatingCartButton({
    Key? key,
    required this.products,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShoppingCartPage(
                  products: products,
                  isDarkMode: isDarkMode,
                  updateCartItemCount: (itemCount) {
                    _updateCartItemCount(context, itemCount);
                  },
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
              CartController.totalUniqueProducts.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateCartItemCount(BuildContext context, int itemCount) {
    // Actualiza el estado de tu página o realiza cualquier otra acción necesaria con el contador del carrito
    // Aquí puedes utilizar la lógica de actualización del carrito de compras
    // Por ejemplo:
    // CartController.addToCart(context, product, itemCount);
  }
}
