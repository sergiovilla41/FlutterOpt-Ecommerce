import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Controllers/CarritoComprasController.dart';
import 'package:mi_app_optativa/src/Models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isDarkMode;
  final void Function(BuildContext context, Product product, int quantity)
      addToCart;
  final void Function(Product product) incrementQuantity;
  final void Function(Product product) decrementQuantity;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isDarkMode,
    required this.addToCart,
    required this.incrementQuantity,
    required this.decrementQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.image), // Agrega la imagen
        title: Text(product.title),
        subtitle:
            Text('\$${product.price.toStringAsFixed(2)}'), // Agrega el precio
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                CartController.incrementQuantity(product);
              },
            ),
            Text(product.quantity
                .toString()), // Muestra la cantidad del producto
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                CartController.decrementQuantity(product);
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                CartController.addToCart(context, product, product.quantity);
              },
            ),
          ],
        ),
      ),
    );
  }
}
