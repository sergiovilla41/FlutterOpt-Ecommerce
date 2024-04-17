class Avatar {
  final int id;
  final String imagen;

  Avatar({
    required this.id,
    required this.imagen,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'],
      imagen: json['imagen'],
    );
  }
}
