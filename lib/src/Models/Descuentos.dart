class Descuentos {
  final int id;
  final String imagen;

  Descuentos({required this.id, required this.imagen});

  factory Descuentos.fromJson(Map<String, dynamic> json) {
    return Descuentos(
      id: json['id'],
      imagen: json['password'],
    );
  }
}
