# bymetoo_ui

Componentes visuales reutilizables de la aplicación **ByMeToo**.

| Componente | Descripción | Estado |
|---|---|---|
| `ByMeTooBottomBar` | Barra de navegación inferior con 4 pestañas (Grupos, Listas, Actividad, Perfil) y botón central `+` para crear una compra | En desarrollo (T-3.2a/b) |

## Instalación

El paquete no se publica en pub.dev. La app lo usa por ruta. En `by_me_too/pubspec.yaml`:

```yaml
dependencies:
  bymetoo_ui:
    path: ../packages/bymetoo_ui
```

## Uso

```dart
import 'package:bymetoo_ui/bymetoo_ui.dart';
```

Ejemplo completo en [`example/`](example/): `cd example && flutter run -d chrome`.

## Desarrollo

```bash
flutter pub get
flutter analyze
flutter test
dart doc        # genera la documentación en doc/api (T-3.7b)
```

Versión de Flutter del equipo: 3.50.1.
