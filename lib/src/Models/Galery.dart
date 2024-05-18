class ImageModel {
  final String url;

  ImageModel({required this.url});

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      url: map['url'],
    );
  }
}
