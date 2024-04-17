// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';
import 'package:mi_app_optativa/src/Controllers/CarritoComprasController.dart';
import 'package:mi_app_optativa/src/Interfaces/CartObserver.dart';
import 'package:mi_app_optativa/src/Mocks/DescuentosMocks.dart';
import 'package:mi_app_optativa/src/Models/Avatar.dart';
import 'package:mi_app_optativa/src/Models/product.dart';
import 'package:mi_app_optativa/src/Service/ProductosService.dart';
import 'package:mi_app_optativa/src/Widgets/Descuentos_widgest.dart';
import 'package:mi_app_optativa/src/Widgets/avatar_widget.dart';
import 'package:mi_app_optativa/src/Widgets/floating_cart_button.dart';
import 'package:mi_app_optativa/src/Widgets/product_card.dart' as Cart;
import 'package:mi_app_optativa/src/Widgets/custom_popup_menu_button.dart'
    as Menu;
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final String username;
  Home({Key? key, required this.username, required String password})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements CartObserver {
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
      List<Product> fetchedProducts = await _productService.fetchProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      // Handle error
      print('Error fetching products: $e');
    }
  }

  void _updateCartItemCount(int itemCount) {
    // Actualiza el estado de tu página o realiza cualquier otra acción necesaria con el contador del carrito
    setState(() {
      // Actualiza el estado de tu widget con el nuevo número de ítems en el carrito
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedAvatar = Provider.of<AvatarProvider>(context).selectedAvatar;
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'User: ${widget.username}',
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 20,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(width: 8),
              AvatarWidget(
                avatar:
                    selectedAvatar, // Pasa el avatar seleccionado al AvatarWidget
                onSelectAvatar: (avatar) {
                  Provider.of<AvatarProvider>(context, listen: false)
                      .setSelectedAvatar(
                          avatar); // Actualiza el avatar seleccionado en el proveedor
                },
              ),
            ],
          ),
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 61, 60, 60)
              : Color.fromARGB(207, 14, 73, 9),
          actions: [
            Menu.CustomPopupMenuButton(isDarkMode: isDarkMode),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
              icon: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode
                    ? Color.fromARGB(255, 236, 234, 234)
                    : Color.fromARGB(255, 175, 167, 54),
              ),
            ),
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
              SizedBox(
                height:
                    100, // Especifica la altura deseada del DescuentosCarousel
                child: DescuentosCarousel(
                  descuentosList: datosDescuentosMock,
                  interval: Duration(seconds: 3),
                  imageSize: 10, // Tamaño de las imágenes en píxeles
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
                      addToCart: (context, product, quantity) {
                        CartController.addToCart(context, product, quantity);
                      },
                      incrementQuantity: (product) {
                        CartController.incrementQuantity(product);
                      },
                      decrementQuantity: (product) {
                        CartController.decrementQuantity(product);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
