import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Models/Avatar.dart';
import 'package:mi_app_optativa/src/Pages/AvatarPickerPage.dart';

class AvatarWidget extends StatelessWidget {
  final Avatar? avatar;
  final Function(Avatar?) onSelectAvatar;

  const AvatarWidget({
    Key? key,
    required this.onSelectAvatar,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedAvatar = await Navigator.push<Avatar?>(
          context,
          MaterialPageRoute(builder: (context) => AvatarPickerPage()),
        );
        onSelectAvatar(selectedAvatar);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: ClipOval(
          child: avatar != null
              ? Image.network(
                  avatar!.imagen,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.account_circle, size: 40),
        ),
      ),
    );
  }
}
