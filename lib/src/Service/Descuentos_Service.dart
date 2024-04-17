import 'package:mi_app_optativa/src/Mocks/DescuentosMocks.dart';
import 'package:mi_app_optativa/src/Models/Descuentos.dart';

class DescuentosService {
  // Método para obtener la lista de descuentos
  List<Descuentos> getDescuentos() {
    // Aquí podrías implementar la lógica para obtener los descuentos de una fuente de datos externa,
    // como una API o una base de datos. Por ahora, simplemente retornaremos la lista estática.
    return datosDescuentosMock;
  }
}
