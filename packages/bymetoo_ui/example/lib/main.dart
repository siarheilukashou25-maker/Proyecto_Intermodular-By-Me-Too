import 'package:material_ui/material_ui.dart';
// ignore: unused_import
import 'package:bymetoo_ui/bymetoo_ui.dart';

/// App de ejemplo del paquete `bymetoo_ui`.
void main() => runApp(const EjemploApp());

/// Muestra los componentes del paquete.
class EjemploApp extends StatelessWidget {
  /// Crea la app de ejemplo.
  const EjemploApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'bymetoo_ui · ejemplo',
      home: Scaffold(
        body: Center(child: Text('Aquí irá ByMeTooBottomBar (T-3.2a)')),
        // bottomNavigationBar: ByMeTooBottomBar(...),
      ),
    );
  }
}
