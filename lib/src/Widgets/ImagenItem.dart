import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Service/FireBaseService.dart';

class FileListScreen extends StatefulWidget {
  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  final FirebaseStorageService _storageService = FirebaseStorageService();
  late List<String> fileNames;

  @override
  void initState() {
    super.initState();
    fetchFileNames();
  }

  Future<void> fetchFileNames() async {
    final directory = "images"; // Reemplaza con tu directorio correcto
    final result = await _storageService.fetchFileNames(directory);

    setState(() {
      fileNames = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Archivos'),
      ),
      body: fileNames == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: fileNames.length,
              itemBuilder: (BuildContext context, int index) {
                final fileName = fileNames[index];
                return FutureBuilder<String>(
                  future: _storageService.getImageURL('images/$fileName'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text(fileName),
                        subtitle: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text(fileName),
                        subtitle: Text(
                            'Error al cargar la imagen: ${snapshot.error}'),
                      );
                    } else {
                      final imageUrl = snapshot.data!;
                      return ListTile(
                        title: Text(fileName),
                        leading: imageUrl.isEmpty
                            ? Icon(Icons
                                .error_outline) // Muestra un icono de error si la URL está vacía
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
