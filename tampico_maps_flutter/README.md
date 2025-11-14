# Tampico Maps - App Móvil Flutter

Aplicación móvil interactiva para descubrir negocios, casas, transporte y servicios en Tampico, Tamaulipas.

## 📋 Características Principales

### 🗺️ Mapa Interactivo
- Google Maps integrado
- Marcadores de diferentes categorías (tiendas, restaurantes, bares, etc.)
- Polylines para rutas de transporte
- Zoom y navegación fluida

### 🏪 Establecimientos
- Tiendas y comercios
- Restaurantes y bares
- Mercados
- Talleres y servicios
- Autolavados
- Inmuebles (casas en renta/venta)

### 🏠 Casas en Renta/Venta
- Fotos de propiedades
- Precios actualizados
- Detalles: recámaras, baños, metros cuadrados
- Contacto del dueño
- Ubicación en mapa

### 📝 Reseñas y Calificaciones
- Sistema de 5 estrellas
- Comentarios de usuarios
- Fotos como prueba
- Reseñas verificadas

### 🚌 Rutas de Transporte
- Líneas de transporte público
- Paradas de autobús
- Horarios y tarifas
- Polylines del recorrido en el mapa

### ⭐ Negocios Premium
- Sección destacada para negocios premium
- Visibilidad mejorada en búsquedas
- Menús y galería de fotos

---

## 🚀 Instalación y Setup

### Requisitos Previos
```bash
- Flutter 3.0 o superior
- Dart 3.0 o superior
- Android Studio o Xcode
- Cuenta de Firebase
```

### 1️⃣ Clonar/Descargar el Proyecto
```bash
cd tampico_maps_flutter
```

### 2️⃣ Instalar Dependencias
```bash
flutter pub get
```

### 3️⃣ Configurar Firebase

#### Android:
```bash
# Descargar google-services.json desde Firebase Console
# Copiarlo a: android/app/google-services.json

# Modificar android/build.gradle:
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.14'
  }
}

# Modificar android/app/build.gradle:
apply plugin: 'com.google.gms.google-services'
```

#### iOS:
```bash
# Descargar GoogleService-Info.plist desde Firebase Console
# Copiarlo a: ios/Runner/GoogleService-Info.plist

# Ejecutar:
cd ios
pod install
cd ..
```

### 4️⃣ Configurar Google Maps API Key

#### Android:
En `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="TU_GOOGLE_MAPS_API_KEY"/>
</application>
```

#### iOS:
En `ios/Runner/GeneratedPluginRegistrant.m`, asegúrate de tener la clave configurada.

### 5️⃣ Ejecutar la App

```bash
# En emulador/dispositivo Android
flutter run

# O específicamente:
flutter run -d <device_id>

# Ver dispositivos disponibles:
flutter devices
```

---

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada
├── firebase_options.dart              # Configuración Firebase
├── models/                            # Modelos de datos
│   ├── establecimiento.dart          # Negocio/Comercio
│   ├── casa.dart                     # Inmueble en renta/venta
│   ├── ruta_transporte.dart          # Rutas de transporte
│   ├── resena.dart                   # Reseñas y calificaciones
│   ├── usuario.dart                  # Datos de usuario
│   └── index.dart                    # Exportaciones
├── screens/                           # Pantallas principales
│   ├── mapa_principal_screen.dart    # Mapa con marcadores
│   └── index.dart                    # Exportaciones
├── services/                          # Servicios Firebase
│   ├── establecimiento_service.dart  # CRUD establecimientos
│   ├── resena_service.dart           # Gestión reseñas
│   ├── casa_service.dart             # Gestión casas
│   ├── ruta_transporte_service.dart  # Gestión rutas
│   └── index.dart                    # Exportaciones
├── widgets/                           # Widgets personalizados
│   └── (widgets reutilizables)
└── utils/                             # Funciones de utilidad
    └── (constantes, helpers)
```

---

## 🔑 Modelos de Datos

### Establecimiento
```dart
Establecimiento(
  id: String,
  nombre: String,
  categoria: String,  // tienda, restaurante, bar, etc.
  descripcion: String,
  latitud: double,
  longitud: double,
  direccion: String,
  telefono: String?,
  whatsapp: String?,
  horario: String?,
  fotos: List<String>,
  menuFotos: List<String>,
  calificacionPromedio: double,
  totalResenas: int,
  esPremium: bool,
  estaDestacado: bool,
  fechaCreacion: DateTime,
)
```

### Casa
```dart
Casa(
  id: String,
  titulo: String,
  descripcion: String,
  latitud: double,
  longitud: double,
  tipo: String,  // 'renta' o 'venta'
  precio: double,
  recamaras: int,
  banos: int,
  metrosCuadrados: double,
  fotos: List<String>,
  nombreDueno: String,
  telefonoDueno: String,
  esPremium: bool,
)
```

### RutaTransporte
```dart
RutaTransporte(
  id: String,
  nombre: String,
  numeroRuta: String,
  operador: String,
  paradas: List<Parada>,
  coordenadas: List<LatLng>,  // Para polyline
  color: String,
  horarioInicio: String,
  horarioFin: String,
  tarifa: double,
)
```

### Reseña
```dart
Resena(
  id: String,
  establecimientoId: String,
  usuarioId: String,
  calificacion: double,  // 1-5
  comentario: String,
  fotosPrueba: List<String>,
  fechaCreacion: DateTime,
  esVerificada: bool,
)
```

---

## 🔥 Firestore Database Structure

### Colección: `establecimientos`
```
{
  "nombre": "Restaurante El Sabor",
  "categoria": "restaurante",
  "descripcion": "...",
  "latitud": 22.27,
  "longitud": -97.86,
  "direccion": "Calle X #123",
  "telefono": "+52 833 123 4567",
  "whatsapp": "+52 833 123 4567",
  "horario": "09:00 - 22:00",
  "fotos": ["url1", "url2"],
  "menuFotos": ["url_menu1"],
  "calificacionPromedio": 4.5,
  "totalResenas": 23,
  "esPremium": true,
  "estaDestacado": true,
  "fechaCreacion": timestamp,
  "datosAdicionales": {}
}
```

### Colección: `casas`
```
{
  "titulo": "Casa en Reforma",
  "descripcion": "Casa de 3 recámaras...",
  "latitud": 22.27,
  "longitud": -97.86,
  "tipo": "venta",
  "precio": 1500000,
  "moneda": "MXN",
  "recamaras": 3,
  "banos": 2,
  "metrosCuadrados": 150,
  "fotos": ["url1", "url2"],
  "nombreDueno": "Juan Pérez",
  "telefonoDueno": "+52 833 123 4567",
  "esPremium": false,
  "fechaCreacion": timestamp,
  "caracteristicas": {
    "garage": true,
    "jardin": true,
    "piscina": false
  }
}
```

### Colección: `rutasTransporte`
```
{
  "nombre": "Centro - Playa",
  "numeroRuta": "12",
  "operador": "Transportes Tampico",
  "paradas": [
    {
      "nombre": "Centro",
      "latitud": 22.27,
      "longitud": -97.86,
      "numeroOrden": 1
    },
    ...
  ],
  "coordenadas": [
    {"latitud": 22.27, "longitud": -97.86},
    ...
  ],
  "color": "#FF6B6B",
  "horarioInicio": "06:00",
  "horarioFin": "22:00",
  "tarifa": 13.00,
  "moneda": "MXN",
  "estaActiva": true,
  "fechaCreacion": timestamp
}
```

### Colección: `resenas`
```
{
  "establecimientoId": "abc123",
  "usuarioId": "user456",
  "nombreUsuario": "Carlos",
  "calificacion": 5,
  "comentario": "Excelente servicio y comida deliciosa",
  "fotosPrueba": ["url1"],
  "totalLikes": 12,
  "fechaCreacion": timestamp,
  "esVerificada": true
}
```

### Colección: `usuarios`
```
{
  "nombre": "Juan Pérez",
  "email": "juan@email.com",
  "fotoPerfil": "url_foto",
  "telefono": "+52 833 123 4567",
  "fechaCreacion": timestamp,
  "establecimientosGuardados": ["id1", "id2"],
  "preferencias": {
    "notificaciones": true,
    "temaOscuro": false
  }
}
```

---

## 📱 Servicios Disponibles

### EstablecimientoService
```dart
final service = EstablecimientoService();

// Obtener todos
List<Establecimiento> todos = await service.obtenerTodos();

// Por categoría
List<Establecimiento> restaurantes = 
    await service.obtenerPorCategoria('restaurante');

// Destacados
List<Establecimiento> destacados = 
    await service.obtenerDestacados();

// Buscar
List<Establecimiento> resultados = 
    await service.buscar('Tampico');

// Stream (tiempo real)
Stream<List<Establecimiento>> stream = 
    service.obtenerStreamTodos();
```

### ResenaService
```dart
final service = ResenaService();

// Obtener reseñas de un establecimiento
List<Resena> resenas = 
    await service.obtenerResenasPorEstablecimiento('id');

// Agregar reseña
bool exito = await service.agregarResena(nuevaResena);

// Stream de reseñas
Stream<List<Resena>> stream = 
    service.obtenerStreamResenas('establecimientoId');
```

### CasaService
```dart
final service = CasaService();

// Obtener todas
List<Casa> casas = await service.obtenerTodas();

// Por tipo
List<Casa> enRenta = await service.obtenerPorTipo('renta');

// Por precio
List<Casa> economicas = 
    await service.filtrarPorPrecio(0, 500000);
```

### RutaTransporteService
```dart
final service = RutaTransporteService();

// Obtener rutas
List<RutaTransporte> rutas = 
    await service.obtenerTodas();

// Por operador
List<RutaTransporte> transportesTampico = 
    await service.obtenerPorOperador('Transportes Tampico');
```

---

## 🎯 Ejemplos de Uso

### Cargar establecimientos en el mapa
```dart
final service = EstablecimientoService();
List<Establecimiento> establecimientos = await service.obtenerTodos();

for (var est in establecimientos) {
  // Crear marcador en Google Maps
  Marker(
    markerId: MarkerId(est.id),
    position: LatLng(est.latitud, est.longitud),
    infoWindow: InfoWindow(title: est.nombre),
  );
}
```

### Dibujar polyline de ruta
```dart
final ruta = await service.obtenerPorId('ruta_id');

Polyline(
  polylineId: PolylineId(ruta.id),
  points: ruta.coordenadas
      .map((c) => LatLng(c.latitud, c.longitud))
      .toList(),
  color: Colors.blue,
  width: 5,
);
```

### Agregar reseña
```dart
final resena = Resena(
  id: 'resena_id',
  establecimientoId: 'est_id',
  usuarioId: 'user_id',
  nombreUsuario: 'Carlos',
  calificacion: 5,
  comentario: 'Excelente lugar',
  fechaCreacion: DateTime.now(),
);

bool exito = await ResenaService().agregarResena(resena);
```

---

## 🔒 Reglas de Firestore (Seguridad)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Públicamente legible
    match /{document=**} {
      allow read: if true;
    }
    
    // Solo admin puede escribir
    match /{document=**} {
      allow write: if request.auth.uid != null && 
                      request.auth.token.admin == true;
    }
    
    // Los usuarios pueden escribir sus propias reseñas
    match /resenas/{document=**} {
      allow create: if request.auth.uid != null;
      allow update: if request.auth.uid == resource.data.usuarioId;
      allow delete: if request.auth.uid == resource.data.usuarioId;
    }
  }
}
```

---

## 🛠️ Troubleshooting

### Error: "Trying to read in SNAPSHOT_READ mode, but no snapshot."
**Solución:** Asegúrate de que Firebase está inicializado antes de usarlo.

### Error: "MissingPluginException"
```bash
flutter clean
flutter pub get
flutter run
```

### Error: "Google Maps API key not valid"
**Solución:** 
- Verifica que la clave esté correcta en AndroidManifest.xml
- Asegúrate de que Google Maps API esté habilitada en Google Cloud Console

### Emulador muy lento
```bash
# Ejecutar con GPU acelerada
emulator -avd <nombre> -gpu host
```

---

## 📦 Paquetes Utilizados

```yaml
# Estado
provider: ^6.0.0

# Mapas
google_maps_flutter: ^2.5.0

# Firebase
firebase_core: ^2.24.0
cloud_firestore: ^4.13.0
firebase_auth: ^4.10.0
firebase_storage: ^11.5.0

# Utilidades
http: ^1.1.0
intl: ^0.19.0
uuid: ^4.0.0
url_launcher: ^6.1.14
cached_network_image: ^3.3.0

# UI
flutter_rating_bar: ^4.0.1
image_picker: ^1.0.4

# Geolocalización
geolocator: ^10.0.0
```

---

## 📋 Checklist de Implementación

- [x] Modelos de datos
- [x] Servicios Firebase
- [x] Pantalla principal con mapa
- [ ] Pantalla de lista de negocios
- [ ] Pantalla de detalle de negocio
- [ ] Pantalla de agregar negocio
- [ ] Pantalla de casas
- [ ] Pantalla de detalle de casa
- [ ] Pantalla de rutas
- [ ] Pantalla de reseñas
- [ ] Autenticación de usuarios
- [ ] Búsqueda avanzada
- [ ] Filtros por categoría
- [ ] Favoritos del usuario
- [ ] Notificaciones push

---

## 🚀 Próximos Pasos

1. Configurar Firebase Console completamente
2. Implementar pantallas adicionales
3. Agregar autenticación
4. Crear API backend si es necesario
5. Testing (unit y widget)
6. Preparar para App Store y Play Store

---

## 📞 Soporte

Para problemas:
1. Revisa los logs: `flutter logs`
2. Limpia el proyecto: `flutter clean`
3. Reinstala dependencias: `flutter pub get`
4. Reconstruye: `flutter run`

---

¡Buena suerte con tu app de Tampico Maps! 🗺️
