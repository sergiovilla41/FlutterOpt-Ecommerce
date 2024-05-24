import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Interfaces/CartObserver.dart';
import 'package:mi_app_optativa/src/Models/product.dart';

class CartController extends ChangeNotifier {
  static List<Product> _cartItems = [];
  static List<CartObserver> _observers = [];
  Set<int> uniqueProductIds = {};
  List<Product> products = [];
  static int totalUniqueProducts = 0;

  static void addObserver(CartObserver observer) {
    _observers.add(observer);
  }

  static void removeObserver(CartObserver observer) {
    _observers.remove(observer);
  }

  static void notifyCartUpdated() {
    for (var observer in _observers) {
      observer.onCartUpdated();
    }
  }

  static void addToCart(BuildContext context, Product product, int quantity) {
    if (quantity >= 1) {
      // Verifica si la cantidad es mayor o igual a 1
      Product? existingProduct =
          _cartItems.firstWhereOrNull((item) => item.id == product.id);
      if (existingProduct != null) {
        // Si el producto ya existe en el carrito, incrementa su cantidad
        existingProduct.quantity += quantity;
      } else {
        // Si el producto no existe en el carrito, agrégalo con la cantidad especificada
        _cartItems.add(product);
        product.quantity = quantity;
      }
      // Actualiza totalUniqueProducts
      totalUniqueProducts = calculateTotalUniqueProducts(_cartItems);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Agregado al carrito: ${product.title} x ${quantity}',
          ),
          duration: Duration(seconds: 1),
        ),
      );

      notifyCartUpdated();
    }
  }

  static void removeProduct(Product product) {
    _cartItems.remove(product);
    updateTotalUniqueProducts(
        _cartItems); // Actualiza el número total de productos únicos
    notifyCartUpdated();
  }

  // Método para incrementar la cantidad de un producto en el carrito
  static void incrementQuantity(Product product) {
    product.quantity++;
    notifyCartUpdated();
  }

  // Método para decrementar la cantidad de un producto en el carrito
  static void decrementQuantity(Product product) {
    if (product.quantity > 0) {
      product.quantity--; // Se decrementa la cantidad incluso si es 0
    }
    notifyCartUpdated();
  }

  // Método para obtener todos los productos en el carrito
  static List<Product> getCartItems() {
    return List.from(_cartItems);
  }

  // Método para calcular el total de productos únicos en el carrito

  static int calculateTotalUniqueProducts(List<Product> products) {
    // Creamos un conjunto para almacenar los identificadores únicos de los productos
    Set<int> uniqueIds = {};

    // Iteramos sobre los productos en la lista pasada como argumento y agregamos sus identificadores únicos al conjunto
    for (var product in products) {
      if (product.quantity > -1) {
        // Solo agregamos los productos con cantidad mayor que cero
        uniqueIds.add(product.id);
      }
    }

    // Devolvemos el tamaño del conjunto, que representa el número de productos únicos
    return uniqueIds.length;
  }

  static void updateTotalUniqueProducts(List<Product> products) {
    totalUniqueProducts = calculateTotalUniqueProducts(products);
  }

  static int getTotalProducts(List<Product> products) {
    int total = 0;
    for (var product in products) {
      total += product.quantity;
    }
    return total;
  }
}
