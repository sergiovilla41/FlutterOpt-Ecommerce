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
