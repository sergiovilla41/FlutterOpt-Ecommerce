import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Controllers/CarritoComprasController.dart';
import 'package:mi_app_optativa/src/Interfaces/CartObserver.dart';
import 'package:mi_app_optativa/src/Pages/Cart.dart';
import 'package:mi_app_optativa/src/Models/product.dart';
import 'package:mi_app_optativa/src/Pages/Joyeria.dart';
import 'package:mi_app_optativa/src/Pages/RopaParaDama.dart';
import 'package:mi_app_optativa/src/Pages/Tecnologia.dart';
import 'package:mi_app_optativa/src/Service/ProductosService.dart';
import 'package:mi_app_optativa/src/Widgets/floating_cart_button.dart';
import 'package:mi_app_optativa/src/Widgets/product_card.dart' as Cart;

class RopaCaballero extends StatefulWidget {
  @override
  _RopaCaballeroState createState() => _RopaCaballeroState();
}

class _RopaCaballeroState extends State<RopaCaballero> implements CartObserver {
  List<Product> products = [];
  bool isDarkMode = false;
  int totalUniqueProducts = 0;
  final ProductService _productService = ProductService();
  @override
  void initState() {
    super.initState();
    CartController.addObserver(this);
    _loadProducts();
    setState(() {});
  }

  @override
  void dispose() {
    CartController.removeObserver(this);
    super.dispose();
  }

  @override
  void onCartUpdated() {
    setState(() {
      CartController.updateTotalUniqueProducts(CartController.getCartItems());
    });
  }

  //Metodo para cargar los productos desde el Service
  void _loadProducts() async {
    try {
      List<Product> fetchedProducts =
          await _productService.fetchProducts(category: 'men%27s%20clothing');
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      // Handle error
      print('Error fetching products: $e');
    }
  }

  void addToCart(BuildContext context, Product product, int quantity) {
    CartController.addToCart(context, product, quantity);
  }

  void incrementQuantity(Product product) {
    CartController.incrementQuantity(product);

    setState(() {
      // Incrementa la cantidad del producto en la lista de productos
    });
  }

  void decrementQuantity(Product product) {
    CartController.decrementQuantity(product);
    setState(() {
      // Este setState actualizará automáticamente el widget después de decrementar la cantidad
    });
  }

  void _updateCartItemCount(int itemCount) {
    // Actualiza el estado de tu página o realiza cualquier otra acción necesaria con el contador del carrito
    setState(() {
      // Actualiza el estado de tu widget con el nuevo número de ítems en el carrito
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Ropa',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 30,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
        leading: IconButton(
          // Aquí está el IconButton para la flecha hacia atrás
          icon: Icon(
            Icons.arrow_back, // Icono de flecha hacia atrás
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(
                context); // Esto hará que la pantalla retroceda cuando se presione el botón de flecha hacia atrás
          },
        ),
        actions: [
          CustomPopupMenuButton(
              isDarkMode: isDarkMode), // Muestra el menú desplegable
        ],
      ),
      floatingActionButton: FloatingCartButton(
        products: products,
        isDarkMode: isDarkMode,
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
                  return Cart.ProductCard(
                    product: product,
                    isDarkMode: isDarkMode,
                    addToCart: addToCart,
                    incrementQuantity: incrementQuantity,
                    decrementQuantity: decrementQuantity,
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
          case 'ropaCaballero': // Agregar la opción para la página RopaCaballero
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RopaCaballero()),
            );
            break;
          case 'ropaDama':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RopaDama()),
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
          value: 'ropaCaballero',
          child: Text(
            'Ropa Caballero',
            style: TextStyle(
              fontFamily: 'FredokaOne',
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'ropaDama',
          child: Text(
            'Ropa Dama',
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
