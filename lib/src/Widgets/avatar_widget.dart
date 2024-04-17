import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Controllers/AvatarController.dart';
import 'package:mi_app_optativa/src/Models/Avatar.dart';
import 'package:mi_app_optativa/src/Pages/AvatarPickerPage.dart';
import 'package:provider/provider.dart';

class AvatarWidget extends StatelessWidget {
  final Avatar? avatar;
  final Function(Avatar?) onSelectAvatar;
  final double imageSize;

  const AvatarWidget({
    Key? key,
    required this.onSelectAvatar,
    this.avatar,
    this.imageSize = 40.0, // Tamaño predeterminado para la imagen
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedAvatar = await Navigator.push<Avatar?>(
          context,
          MaterialPageRoute(builder: (context) => AvatarPickerPage()),
        );
        Provider.of<AvatarProvider>(context, listen: false)
            .setSelectedAvatar(selectedAvatar);
      },
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(64, 224, 224, 224),
        ),
        child: ClipOval(
          child: avatar != null
              ? Image.network(
                  avatar!.imagen,
                  fit: BoxFit.cover,
                  width: imageSize, // Ajusta el tamaño de la imagen
                  height: imageSize, // Ajusta el tamaño de la imagen
                )
              : Icon(Icons.account_circle, size: imageSize),
        ),
      ),
    );
  }
}
