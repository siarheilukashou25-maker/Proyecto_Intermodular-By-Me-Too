# T-3.5 · Plan de pruebas de widget: `ByMeTooBottomBar`

**Responsable:** Sergei (DevOps & QA) · **Sprint 3** (16–30 nov 2026)
**Base:** especificación de Elias en #164 (23/11/2026) · **Implementación:** Roberto (T-3.2a/b)

## 1. Objetivo y alcance

Comprobar con `flutter_test` que la barra inferior `ByMeTooBottomBar` cumple la especificación: se pinta bien, marca la pestaña activa, avisa al pulsar cada elemento, es accesible y no se rompe con temas, textos grandes o pantallas estrechas.

| Dentro del alcance | Fuera del alcance |
|---|---|
| El widget `ByMeTooBottomBar` del paquete `bymetoo_ui` | Contenido de las pantallas Grupos, Listas, Actividad y Perfil |
| Su uso dentro de un `Scaffold` (botón `+` acoplado) | El formulario del ticket de compra |
| Pruebas golden de su aspecto | Pruebas en dispositivo real (T-3.8) |

## 2. API que se supone

La especificación todavía no tiene tabla de parámetros. El plan supone esta API y se ajusta cuando Roberto la publique:

| Parámetro | Tipo | Obligatorio | Qué hace |
|---|---|---|---|
| `currentIndex` | `int` (0–3) | Sí | Pestaña activa: 0 Grupos, 1 Listas, 2 Actividad, 3 Perfil |
| `onTabSelected` | `ValueChanged<int>` | Sí | Se llama con el índice de la pestaña pulsada |
| `onCreatePurchase` | `VoidCallback` | Sí | Se llama al pulsar el botón central `+` |

Uso esperado: `Scaffold(bottomNavigationBar: ByMeTooBottomBar(...), floatingActionButton: ..., floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked)`. Hay que confirmar con Roberto si el botón `+` va dentro del widget o lo pone la pantalla.

## 3. Herramientas

- `flutter_test` (incluido en el SDK): `testWidgets`, `WidgetTester`, `find`, `expect`.
- Directrices de accesibilidad de `flutter_test`: `androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`.
- Golden tests: `matchesGoldenFile` y `flutter test --update-goldens`.
- Flutter 3.50.1 (la versión fijada del equipo). En esta versión los widgets de Material están en el paquete `material_ui` (`import 'package:material_ui/material_ui.dart';`); `package:flutter/material.dart` está obsoleto desde 3.47 y `flutter analyze` lo marca.

## 4. Criterio de aceptación

- Todos los casos de las secciones 5.1 a 5.6 pasan con `flutter test`.
- `flutter analyze` sin errores.
- Cada fallo encontrado se registra como issue con la plantilla de bug y se enlaza al caso (p. ej. «I-03»).

## 5. Casos de prueba

Cada caso monta el widget en un `MaterialApp` + `Scaffold` con `currentIndex` y callbacks que registran las llamadas.

### 5.1 Renderizado (R) · T-3.5a

| ID | Qué se comprueba | Resultado esperado |
|---|---|---|
| R-01 | Hay un `BottomAppBar` | `find.byType(BottomAppBar)` encuentra uno |
| R-02 | Textos de las pestañas | Aparecen «Grupos», «Listas», «Actividad» y «Perfil», una vez cada uno |
| R-03 | Orden de izquierda a derecha | Grupos < Listas < `+` < Actividad < Perfil (posición X con `tester.getCenter`) |
| R-04 | Botón central | Hay un botón con el icono `+` centrado horizontalmente |
| R-05 | Recorte (notch) | `BottomAppBar.shape` es un `NotchedShape` (p. ej. `CircularNotchedRectangle`) |
| R-06 | Ubicación del botón | `Scaffold.floatingActionButtonLocation == centerDocked` |

### 5.2 Selección (S) · T-3.5a

| ID | Qué se comprueba | Resultado esperado |
|---|---|---|
| S-01 | `currentIndex` 0, 1, 2, 3 (test parametrizado con bucle) | Solo la pestaña de ese índice aparece como seleccionada |
| S-02 | El indicador no depende solo del color | La pestaña activa cambia también el icono (relleno/contorno) o tiene un contenedor de fondo |
| S-03 | Semántica de selección | La pestaña activa tiene `isSelected: true` en su nodo de `Semantics`; las demás, `false` |
| S-04 | `currentIndex` fuera de rango (−1, 4) | Lanza `AssertionError` (`expect(() => ..., throwsAssertionError)`) |
| S-05 | Reconstrucción con otro `currentIndex` | Al hacer `pumpWidget` con un índice nuevo, el resaltado se mueve |

### 5.3 Interacción (I) · T-3.5a

| ID | Qué se comprueba | Resultado esperado |
|---|---|---|
| I-01 | Tap en cada pestaña | `onTabSelected` se llama una vez con 0, 1, 2 o 3 |
| I-02 | Tap en «Listas» | `onTabSelected(1)` (el ejemplo de la plantilla de bug) |
| I-03 | Tap en la pestaña ya activa | Comportamiento a decidir con Roberto: no llamar, o llamar igualmente. El test fija la decisión |
| I-04 | Tap en `+` | `onCreatePurchase` se llama una vez y `onTabSelected` no se llama |
| I-05 | Tap en `+` no cambia la pestaña | Tras el tap, la pestaña activa sigue siendo la misma |
| I-06 | Dos taps rápidos en `+` | Queda registrado qué pasa (¿una hoja o dos?). Se decide con Roberto |
| I-07 | Integración: `+` abre la hoja inferior | En una pantalla de prueba con `showModalBottomSheet`, tras `pumpAndSettle` aparece un `BottomSheet` |
| I-08 | Integración: no se pierde el estado | Con `IndexedStack` en la pantalla: escribir en un `TextField` de Listas, ir a Perfil y volver; el texto sigue |

### 5.4 Accesibilidad (A) · T-3.5a

| ID | Qué se comprueba | Resultado esperado |
|---|---|---|
| A-01 | Tamaño mínimo táctil iOS (44×44) | `meetsGuideline(iOSTapTargetGuideline)` |
| A-02 | Tamaño mínimo táctil Android (48×48) | `meetsGuideline(androidTapTargetGuideline)` |
| A-03 | Todos los elementos pulsables tienen etiqueta | `meetsGuideline(labeledTapTargetGuideline)` |
| A-04 | Etiqueta del botón central | `find.bySemanticsLabel('Crear compra')` encuentra el botón |
| A-05 | Contraste de los textos | `meetsGuideline(textContrastGuideline)` en tema claro y oscuro |
| A-06 | Espacio entre botones | Los rectángulos de los 5 elementos no se solapan (`tester.getRect`) |

Para A-01..A-05 hace falta `final handle = tester.ensureSemantics();` al principio y `handle.dispose();` al final.

### 5.5 Tema y tamaños (T) · T-3.5a

| ID | Qué se comprueba | Resultado esperado |
|---|---|---|
| T-01 | Tema claro y oscuro | Se pinta sin excepciones; los colores salen del `ThemeData`, no fijos en el `build` |
| T-02 | Texto grande (`TextScaler.linear(2.0)`) | Sin overflow (`tester.takeException()` es `null`) |
| T-03 | Pantalla estrecha (320×568) | Sin overflow y los 5 elementos visibles |
| T-04 | Pantalla ancha (tablet 1024×768) | Sin overflow; la barra ocupa todo el ancho |

### 5.6 Golden (G) · T-3.5b

| ID | Imagen | Configuración |
|---|---|---|
| G-01..G-04 | `goldens/bottom_bar_tab0..3_light.png` | `currentIndex` 0–3, tema claro, 390×844 |
| G-05..G-08 | `goldens/bottom_bar_tab0..3_dark.png` | `currentIndex` 0–3, tema oscuro |
| G-09 | `goldens/bottom_bar_textscale2.png` | Tema claro, `TextScaler.linear(2.0)` |

Reglas para los golden:
- Las imágenes se generan y se comparan **solo en Linux** (la CI usa `ubuntu-latest`), porque Windows y macOS pintan las fuentes distinto y darían falsos fallos.
- Los tests golden llevan `tags: ['golden']`. En Windows se ejecuta `flutter test --exclude-tags golden`.
- Para regenerar: `flutter test --tags golden --update-goldens` en Linux, y se revisa el cambio de imagen en el PR.

### 5.7 Tests con datos (D) · T-3.5b

El widget no conoce los datos (T-3.3a), así que los mocks solo hacen falta en la integración con la app. Cuando exista el repositorio abstracto de Pablo (T-3.4a), se usa `mocktail` (`dev_dependencies: mocktail`) para simularlo.

| ID | Qué se comprueba | Resultado esperado |
|---|---|---|
| D-01 | El controller (T-3.4b) recibe `onTabSelected` | Con un repositorio simulado, el índice del controller cambia y la barra se repinta |
| D-02 | Error del repositorio al abrir Listas | La barra sigue funcionando; la pantalla muestra el error |

## 6. Estructura de ficheros

```
packages/bymetoo_ui/
  lib/src/bymetoo_bottom_bar.dart        ← Roberto
  test/bymetoo_bottom_bar_test.dart      ← R, S, I-01..I-06, A, T
  test/bymetoo_bottom_bar_golden_test.dart ← G
  test/goldens/*.png
by_me_too/
  test/navegacion_test.dart              ← I-07, I-08 (integración con pantallas)
dart_test.yaml                           ← declara la etiqueta golden
```

## 7. Dependencias y puntos abiertos

| Depende de | Estado (24/11) |
|---|---|
| Especificación #164 (Elias) | Hecha, falta la tabla de parámetros |
| Widget T-3.2a/b (Roberto) | Sin empezar |
| Proyecto Flutter base | Hecho (`by_me_too/`, rama `siarhei-branch`) |
| Paquete `packages/bymetoo_ui` (T-3.7a) | Hecho el esqueleto |
| Repositorio y modelo (T-3.4a, Pablo) | Sin empezar; necesario para los tests con datos |

Puntos a decidir con Roberto: API final (sección 2); quién pone el botón `+`; I-03 (tap en la pestaña activa); I-06 (doble tap en `+`); etiqueta exacta del botón central.

## Fuentes

- Flutter Docs, *An introduction to widget testing*: https://docs.flutter.dev/cookbook/testing/widget/introduction
- Flutter Docs, *Tap, drag, and enter text*: https://docs.flutter.dev/cookbook/testing/widget/tap-drag
- API `flutter_test` – `meetsGuideline` / `AccessibilityGuideline`: https://api.flutter.dev/flutter/flutter_test/AccessibilityGuideline-class.html
- API `matchesGoldenFile`: https://api.flutter.dev/flutter/flutter_test/matchesGoldenFile.html
- API `BottomAppBar`: https://api.flutter.dev/flutter/material/BottomAppBar-class.html
- Apple, *Human Interface Guidelines – Accessibility* (44×44 pt): https://developer.apple.com/design/human-interface-guidelines/accessibility
- Material Design, *Accessibility – touch targets* (48×48 dp): https://m3.material.io/foundations/designing/structure
