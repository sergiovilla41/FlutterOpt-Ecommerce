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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Avatar',
          style: TextStyle(
            fontFamily: 'FredokaOne',
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 61, 60, 60)
            : Color.fromARGB(207, 14, 73, 9), // Color del fondo del AppBar
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
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
                    Color.fromARGB(255, 123, 153, 114),
                    Color.fromARGB(0, 191, 255, 191),
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
        backgroundColor: isDarkMode
            ? Color.fromARGB(207, 14, 73, 9)
            : Color.fromARGB(255, 123, 153, 114),
        child: Icon(
          Icons.check,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
