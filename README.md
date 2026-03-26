# PoC Google Maps — Flutter

POC de integración de Google Maps en Flutter con clustering dinámico, geolocalización y carga de markers por bounding box desde una API REST.

---

## Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| `google_maps_flutter` | `2.14.0` | Renderizado del mapa |
| `flutter_riverpod` | `3.2.1` | Gestión de estado |
| `go_router` | `17.1.0` | Navegación declarativa |
| `dio` | `5.9.1` | Cliente HTTP |
| `geolocator` | `14.0.2` | Geolocalización del dispositivo |

**Flutter SDK:** `3.10.8`

---

## Configuración de Google Maps API

> Documentación completa: [Integración API Google Maps](https://dealheure.atlassian.net/wiki/x/AYBY)

Crea un proyecto en [Google Cloud Console](https://developers.google.com/maps/documentation/embed/get-api-key?hl=es-419) y obtén una API key con la API **Maps SDK for Android** y **Maps SDK for iOS** habilitadas.

### Android

1. Agrega la API key en `android/gradle.properties`:
   ```properties
   GOOGLE_MAPS_API_KEY=TU_API_KEY
   ```

### iOS

1. Agrega la API key en `ios/Runner/Config.xcconfig`:
   ```
   GOOGLE_MAPS_API_KEY=TU_API_KEY
   ```

---

## Inicialización en emuladores

### Android

```bash
# Listar emuladores disponibles
flutter emulators

# Lanzar un emulador
flutter emulators --launch <emulator_id>

# Correr la app
flutter run
```

> Asegúrate de que el emulador tenga **Google Play Services** instalado (imagen `Google APIs` o `Google Play`). Las imágenes AOSP no incluyen soporte para Google Maps.

### iOS

```bash
# Listar simuladores disponibles
open -a Simulator
# o
xcrun simctl list devices

# Correr la app en el simulador
flutter run
# o para un dispositivo específico
flutter run -d "iPhone 16"
```

> Requiere Xcode instalado. Ejecuta `pod install` dentro de `ios/` si es la primera vez o tras cambios en dependencias nativas:
> ```bash
> cd ios && pod install && cd ..
> ```

---

## Contrato JSON de la API

### Request — `GET /markers`

Query parameters enviados al endpoint:

| Parámetro | Tipo | Descripción |
|---|---|---|
| `southwest_lat` | `double` | Latitud suroeste del bounding box |
| `southwest_lng` | `double` | Longitud suroeste del bounding box |
| `northeast_lat` | `double` | Latitud noreste del bounding box |
| `northeast_lng` | `double` | Longitud noreste del bounding box |
| `zoom` | `int` | Nivel de zoom lógico (discretizado) |

**Ejemplo:**
```
GET /markers?southwest_lat=48.84&southwest_lng=2.33&northeast_lat=48.87&northeast_lng=2.37&zoom=14
```

### Response

```json
{
  "data": [
    {
      "marker_id": "abc123",
      "category": "restaurant",
      "latitude": 48.8566,
      "longitude": 2.3522,
      "count": 1
    },
    {
      "marker_id": null,
      "category": "cluster",
      "latitude": 48.860,
      "longitude": 2.360,
      "count": 12
    }
  ]
}
```

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `marker_id` | `string` | Solo si no es cluster | ID único del marker |
| `category` | `string` | Sí | `restaurant`, `hotel`, `store` o `cluster` |
| `latitude` | `double` | Sí | Latitud del marker |
| `longitude` | `double` | Sí | Longitud del marker |
| `count` | `int` | No (default `1`) | Cantidad de items agrupados (clusters) |

> Los clusters tienen `category: "cluster"` y `marker_id: null`. Su ID interno se genera automáticamente como `cluster_<lat>_<lng>_<count>`.

---

## Gestor del mapa — Comportamiento y lógica

### Configuración (`MapFetchConfig`)

| Parámetro | Valor por defecto | Descripción |
|---|---|---|
| `debounceDelayMs` | `300 ms` | Espera tras el fin del movimiento antes de hacer fetch |
| `bufferMultiplier` | `1.5` | Factor de expansión del bounding box para pre-cargar markers fuera del área visible |
| `zoomStep` | `1.0` | Tamaño del paso para discretizar el zoom continuo en un zoom lógico entero |
| `minZoomChangeForFetch` | `1.0` | Cambio mínimo en zoom lógico para forzar un nuevo fetch |
| `apiBaseUrl` | `https://api.example.com` | URL base de la API |

### Debouncer

Cada vez que el usuario termina de mover o hacer zoom en el mapa (`onCameraIdle`), se activa un `Debouncer` de **300 ms**. Esto evita disparar requests en cada frame de la animación y solo realiza la petición cuando la cámara lleva al menos 300 ms sin moverse.

### Relación zoom → fetch

El zoom continuo de Google Maps (e.g. `14.7`) se **discretiza** mediante:

```
zoomLogico = floor(zoom / zoomStep)
```

Con `zoomStep = 1.0`, el zoom lógico es simplemente el entero inferior del zoom de la cámara. Se realiza un nuevo fetch únicamente si:

1. **El zoom lógico cambió** en `≥ minZoomChangeForFetch` (1 nivel), o
2. **El bounding box actual no está contenido** dentro del último bounding box solicitado.

Esto evita re-fetches innecesarios cuando el usuario solo desplaza levemente el mapa dentro de un área ya cargada.

### Pre-carga de bounding box

El bounding box enviado al API es **1.5× más grande** que el área visible (`bufferMultiplier`). Esto permite que los markers aparezcan inmediatamente al desplazarse levemente, sin esperar un nuevo request.

### Cancelación de requests concurrentes

Cada llamada al API incrementa un `_requestId`. Si llega una respuesta de un request anterior (porque el usuario movió el mapa rápido), esta se descarta silenciosamente. Solo se aplica al estado la respuesta del request más reciente.

### Visibilidad del mapa

El fetch solo se ejecuta cuando la pantalla del mapa es visible (`mapVisibilityProvider = true`). Al navegar a otra pestaña se deshabilita el fetch automáticamente.

---

## Estructura del proyecto

```
lib/
├── config/          # DioConfig, MapViewConfig, MapFetchConfig
├── data/
│   ├── helpers/     # MapsMarkerMapper, MarkerIconResolver, ClusterIcon, ProductMapper
│   └── services/    # MapsMarkerService, ProductService, LocationService
├── models/
│   ├── domain/      # Marker, Product, CategoryMarker
│   └── dto/         # MapsMarkersRequestDto, MapsMarkersResponseDto, ProductDto
├── providers/       # core_providers, maps_providers, product_providers
├── routing/         # GoRouter, Routes
├── ui/
│   ├── home/        # HomeScreen
│   ├── maps/        # MapsScreen, MapsViewModel, MapsState
│   ├── navbar/      # NavBar
│   └── products/    # ProductsBottomSheet, ProductsViewModel, ProductsState
└── utils/           # Debouncer
```
