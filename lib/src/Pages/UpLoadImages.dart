import 'dart:html' as html;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';
import 'package:mi_app_optativa/src/Widgets/avatar_widget.dart';
import 'package:provider/provider.dart';

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  Uint8List? _imageData;
  String? _imageUrl;
  bool isDarkMode = false;
  bool _isUploading = false; // Nuevo estado para controlar la carga

  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar cualquier variable necesaria
  }

  Future<void> _uploadImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file); // Cambiado a readAsDataUrl
      reader.onLoadEnd.listen((loadEndEvent) async {
        final result = reader.result;
        setState(() {
          if (result is String) {
            // Convertir la cadena base64 a Uint8List
            _imageData = _convertDataUrlToUint8List(result);
            _imageUrl = null; // Limpiar la URL de la imagen previa
            _isUploading = true; // Indicar que se está subiendo la imagen
          }
        });

        final ref = FirebaseStorage.instance
            .ref()
            .child('images')
            .child(DateTime.now().toString() + '.jpg');
        final uploadTask = ref.putData(_imageData!);
        await uploadTask;

        final downloadURL = await ref.getDownloadURL();
        setState(() {
          _imageUrl = downloadURL;
          _isUploading = false; // Indicar que la carga ha finalizado
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagen cargada exitosamente')),
        );
      });
    });
  }

  Uint8List _convertDataUrlToUint8List(String dataUrl) {
    final base64EncodedString = dataUrl.split(',').last;
    return Uint8List.fromList(base64.decode(base64EncodedString));
  }

  @override
  Widget build(BuildContext context) {
    final selectedAvatar = Provider.of<AvatarProvider>(context).selectedAvatar;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              child: Text(
                'Subir Imagen',
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 22,
                  color: isDarkMode ? Colors.white : Colors.white,
                ),
              ),
            ),
            AvatarWidget(
              avatar: selectedAvatar,
              onSelectAvatar: (avatar) {
                Provider.of<AvatarProvider>(context, listen: false)
                    .setSelectedAvatar(avatar);
              },
            ),
          ],
        ),
        backgroundColor: isDarkMode
            ? Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(220, 8, 81, 177),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Color.fromARGB(255, 36, 70, 36),
                    Color.fromARGB(179, 22, 24, 23)
                  ]
                : [
                    Color.fromARGB(255, 11, 90, 128),
                    Color.fromARGB(0, 31, 28, 167)
                  ],
            begin: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isUploading
                  ? CircularProgressIndicator() // Indicador de carga
                  : _imageUrl == null
                      ? Text(
                          'Selecciona una imagen',
                          style: TextStyle(
                            color: Colors.white, // Cambia el color del texto
                            fontSize: 20.0, // Cambia el tamaño del texto
                          ),
                        )
                      : Icon(
                          Icons.check_circle, // Icono de confirmación
                          color: Color.fromARGB(255, 70, 148, 184),
                          size: 50,
                        ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadImage,
                child: Text('Seleccionar imagen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
