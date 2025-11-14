import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;

/// Configuración de Firebase para la app
/// Reemplaza estos valores con tus credenciales de Firebase
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    if (Platform.isWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  // Configuración para Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TU_API_KEY_ANDROID',
    appId: '1:123456789:android:xxxxxxxxxxxxxxxxxx',
    messagingSenderId: '123456789',
    projectId: 'tu-proyecto-firebase',
    storageBucket: 'tu-proyecto-firebase.appspot.com',
  );

  // Configuración para iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TU_API_KEY_IOS',
    appId: '1:123456789:ios:yyyyyyyyyyyyyyyy',
    messagingSenderId: '123456789',
    projectId: 'tu-proyecto-firebase',
    storageBucket: 'tu-proyecto-firebase.appspot.com',
    iosBundleId: 'com.example.tampicoMaps',
  );

  // Configuración para Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'TU_API_KEY_WEB',
    appId: '1:123456789:web:zzzzzzzzzzzzzzzz',
    messagingSenderId: '123456789',
    projectId: 'tu-proyecto-firebase',
    storageBucket: 'tu-proyecto-firebase.appspot.com',
    authDomain: 'tu-proyecto-firebase.firebaseapp.com',
  );
}

/// INSTRUCCIONES PARA CONFIGURAR FIREBASE
/// 
/// 1. Ve a https://console.firebase.google.com
/// 2. Crea un nuevo proyecto llamado "tampico-maps"
/// 3. Agrega las siguientes plataformas:
///    - Android
///    - iOS
///    - Web (si lo necesitas)
/// 
/// 4. Para Android:
///    - Descarga google-services.json
///    - Colócalo en: android/app/google-services.json
///    - Actualiza el apiKey y appId aquí
/// 
/// 5. Para iOS:
///    - Descarga GoogleService-Info.plist
///    - Colócalo en: ios/Runner/GoogleService-Info.plist
///    - Actualiza el apiKey y appId aquí
/// 
/// 6. Para Web:
///    - Copia las credenciales de Firebase
///    - Actualiza los valores aquí
/// 
/// 7. En Firebase Console:
///    - Ve a Firestore Database
///    - Crea una base de datos en modo de prueba
///    - Crea las siguientes colecciones:
///      * establecimientos
///      * casas
///      * rutasTransporte
///      * resenas
///      * usuarios
/// 
/// 8. En Authentication:
///    - Habilita Email/Password
///    - Habilita Google Sign-In (opcional)
