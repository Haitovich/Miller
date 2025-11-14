import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

/// Servicio para gestionar Casas en Firestore
class CasaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _coleccion = 'casas';

  /// Obtener todas las casas
  Future<List<Casa>> obtenerTodas() async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .orderBy('fechaCreacion', descending: true)
          .get();
      return snapshot.docs.map((doc) => Casa.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error al obtener casas: $e');
      return [];
    }
  }

  /// Obtener casas por tipo (renta o venta)
  Future<List<Casa>> obtenerPorTipo(String tipo) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('tipo', isEqualTo: tipo)
          .orderBy('fechaCreacion', descending: true)
          .get();
      return snapshot.docs.map((doc) => Casa.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error al obtener casas por tipo: $e');
      return [];
    }
  }

  /// Obtener casas destacadas (Premium)
  Future<List<Casa>> obtenerDestacadas() async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('esPremium', isEqualTo: true)
          .orderBy('fechaCreacion', descending: true)
          .limit(10)
          .get();
      return snapshot.docs.map((doc) => Casa.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error al obtener casas destacadas: $e');
      return [];
    }
  }

  /// Obtener una casa por ID
  Future<Casa?> obtenerPorId(String id) async {
    try {
      final doc = await _firestore.collection(_coleccion).doc(id).get();
      if (doc.exists) {
        return Casa.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error al obtener casa: $e');
      return null;
    }
  }

  /// Crear una nueva casa
  Future<String?> crearCasa(Casa casa) async {
    try {
      final docRef = await _firestore.collection(_coleccion).add(casa.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error al crear casa: $e');
      return null;
    }
  }

  /// Actualizar una casa
  Future<bool> actualizarCasa(Casa casa) async {
    try {
      await _firestore
          .collection(_coleccion)
          .doc(casa.id)
          .update(casa.toFirestore());
      return true;
    } catch (e) {
      print('Error al actualizar casa: $e');
      return false;
    }
  }

  /// Eliminar una casa
  Future<bool> eliminarCasa(String id) async {
    try {
      await _firestore.collection(_coleccion).doc(id).delete();
      return true;
    } catch (e) {
      print('Error al eliminar casa: $e');
      return false;
    }
  }

  /// Stream de casas en tiempo real
  Stream<List<Casa>> obtenerStreamTodas() {
    return _firestore
        .collection(_coleccion)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Casa.fromFirestore(doc)).toList());
  }

  /// Filtrar casas por rango de precio
  Future<List<Casa>> filtrarPorPrecio(double precioMin, double precioMax) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('precio', isGreaterThanOrEqualTo: precioMin)
          .where('precio', isLessThanOrEqualTo: precioMax)
          .get();
      return snapshot.docs.map((doc) => Casa.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error al filtrar casas por precio: $e');
      return [];
    }
  }
}
