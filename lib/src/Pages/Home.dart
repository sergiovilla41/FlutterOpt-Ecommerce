import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';
import 'package:mi_app_optativa/src/Service/FireBaseService.dart';
import 'package:mi_app_optativa/src/Pages/UpLoadImages.dart';
import 'package:mi_app_optativa/src/Widgets/full_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = false;

  late Future<List<String>> _fileNamesFuture;

  @override
  void initState() {
    super.initState();
    _fileNamesFuture = FirebaseStorageService().fetchFileNames('images');
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
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 2),
                  child: Text(
                    'Galería',
                    style: TextStyle(
                      fontFamily: 'FredokaOne',
                      fontSize: 22,
                      color: isDarkMode ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
              // Agrega aquí tu widget AvatarWidget
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
          child: FutureBuilder<List<String>>(
            future: _fileNamesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar los archivos'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay archivos disponibles'));
              } else {
                final imageFiles = snapshot.data!
                    .where((fileName) =>
                        fileName.endsWith('.jpg') ||
                        fileName.endsWith('.png') ||
                        fileName.endsWith('.jpeg'))
                    .toList();
                if (imageFiles.isEmpty) {
                  return Center(
                      child: Text('No hay archivos de imagen disponibles'));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        3, // Cambia este valor según el número de columnas que desees
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: imageFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    final fileName = imageFiles[index];
                    return FutureBuilder<String>(
                      future: FirebaseStorageService()
                          .getImageURL('images/$fileName'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Icon(Icons.error));
                        } else {
                          final imageUrl = snapshot.data!;
                          return imageUrl.isEmpty
                              ? Center(child: Icon(Icons.error_outline))
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullImageScreen(
                                          imageUrl: imageUrl,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  ),
                                );
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageUploader()),
            );
          },
          tooltip: 'Subir imagen',
          child: Icon(Icons.folder),
        ),
      ),
    );
  }
}
