import 'package:mi_app_optativa/src/Mocks/UsersMocks.dart'; // Importa tu lista de mock de usuarios
import 'package:mi_app_optativa/src/Models/Usuarios.dart'; // Importa la clase User

class UserService {
  Future<List<User>> fetchUsers() async {
    // Simplemente devuelve la lista de usuarios mock en lugar de hacer una solicitud HTTP
    return datosUsuarioMock;
  }
}
