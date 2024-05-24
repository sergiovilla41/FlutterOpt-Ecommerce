import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:http/http.dart' as http; // Importa el paquete http

class ImageEditorScreen extends StatelessWidget {
  final String imageUrl;

  ImageEditorScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Imagen'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _loadImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error al cargar la imagen');
            } else {
              return ImageEditor(
                image: snapshot.data,
              );
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List> _loadImage() async {
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }
}
