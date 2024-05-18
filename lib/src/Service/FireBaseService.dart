import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<List<String>> fetchFileNames(String directory) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(directory);
      final result = await ref.listAll();
      final fileNames = result.items.map((item) => item.name).toList();
      return fileNames;
    } catch (e) {
      print('Error al listar los archivos: $e');
      return [];
    }
  }

  Future<String> getImageURL(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error al obtener la URL de la imagen: $e');
      return '';
    }
  }
}
