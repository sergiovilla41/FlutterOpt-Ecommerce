import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Models/Avatar.dart';
import 'package:mi_app_optativa/src/Service/avatar_service.dart';

class AvatarPickerPage extends StatefulWidget {
  @override
  _AvatarPickerPageState createState() => _AvatarPickerPageState();
}

class _AvatarPickerPageState extends State<AvatarPickerPage> {
  Avatar? _selectedAvatar;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define los colores y estilos para el AppBar y el FAB
    Color appBarColor = isDarkMode
        ? const Color.fromARGB(255, 61, 60, 60)
        : Color.fromARGB(220, 8, 81, 177);
    Color fabColor = isDarkMode
        ? Color.fromARGB(255, 255, 255, 255)
        : Color.fromARGB(220, 8, 81, 177);
    Color iconColor =
        isDarkMode ? Colors.white : const Color.fromARGB(255, 247, 247, 247);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Avatar',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            color: isDarkMode
                ? Colors.white
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: iconColor,
          ),
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
                    Color.fromARGB(179, 22, 24, 23),
                  ]
                : [
                    Color.fromARGB(220, 8, 81, 177),
                    Color.fromARGB(210, 97, 104, 136),
                  ],
            begin: Alignment.topCenter,
          ),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: AvatarService.getAvatars().length,
          itemBuilder: (BuildContext context, int index) {
            final avatar = AvatarService.getAvatars()[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatar = avatar;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedAvatar?.id == avatar.id
                        ? Color.fromARGB(255, 123, 153, 114)
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Image.network(
                  avatar.imagen,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedAvatar);
        },
        backgroundColor: fabColor,
        child: Icon(
          Icons.check,
          color: iconColor,
        ),
      ),
    );
  }
}
