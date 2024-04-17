import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Models/Avatar.dart';

class AvatarProvider extends ChangeNotifier {
  Avatar? _selectedAvatar;

  Avatar? get selectedAvatar => _selectedAvatar;

  void setSelectedAvatar(Avatar? avatar) {
    _selectedAvatar = avatar;
    notifyListeners();
  }
}
