import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

/// Servicio para gestionar Rutas de Transporte en Firestore
class RutaTransporteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _coleccion = 'rutasTransporte';

  /// Obtener todas las rutas
  Future<List<RutaTransporte>> obtenerTodas() async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('estaActiva', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => RutaTransporte.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al obtener rutas: $e');
      return [];
    }
  }

  /// Obtener una ruta por ID
  Future<RutaTransporte?> obtenerPorId(String id) async {
    try {
      final doc = await _firestore.collection(_coleccion).doc(id).get();
      if (doc.exists) {
        return RutaTransporte.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error al obtener ruta: $e');
      return null;
    }
  }

  /// Crear una nueva ruta
  Future<String?> crearRuta(RutaTransporte ruta) async {
    try {
      final docRef =
          await _firestore.collection(_coleccion).add(ruta.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error al crear ruta: $e');
      return null;
    }
  }

  /// Actualizar una ruta
  Future<bool> actualizarRuta(RutaTransporte ruta) async {
    try {
      await _firestore
          .collection(_coleccion)
          .doc(ruta.id)
          .update(ruta.toFirestore());
      return true;
    } catch (e) {
      print('Error al actualizar ruta: $e');
      return false;
    }
  }

  /// Eliminar una ruta
  Future<bool> eliminarRuta(String id) async {
    try {
      await _firestore.collection(_coleccion).doc(id).delete();
      return true;
    } catch (e) {
      print('Error al eliminar ruta: $e');
      return false;
    }
  }

  /// Stream de rutas en tiempo real
  Stream<List<RutaTransporte>> obtenerStreamTodas() {
    return _firestore
        .collection(_coleccion)
        .where('estaActiva', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RutaTransporte.fromFirestore(doc))
            .toList());
  }

  /// Obtener rutas por operador
  Future<List<RutaTransporte>> obtenerPorOperador(String operador) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('operador', isEqualTo: operador)
          .where('estaActiva', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => RutaTransporte.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al obtener rutas por operador: $e');
      return [];
    }
  }
}
