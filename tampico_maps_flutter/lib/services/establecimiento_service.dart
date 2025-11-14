import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

/// Servicio para gestionar Establecimientos en Firestore
class EstablecimientoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _coleccion = 'establecimientos';

  /// Obtener todos los establecimientos
  Future<List<Establecimiento>> obtenerTodos() async {
    try {
      final snapshot = await _firestore.collection(_coleccion).get();
      return snapshot.docs
          .map((doc) => Establecimiento.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al obtener establecimientos: $e');
      return [];
    }
  }

  /// Obtener establecimientos por categoría
  Future<List<Establecimiento>> obtenerPorCategoria(String categoria) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('categoria', isEqualTo: categoria)
          .get();
      return snapshot.docs
          .map((doc) => Establecimiento.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al obtener establecimientos por categoría: $e');
      return [];
    }
  }

  /// Obtener establecimientos destacados/premium
  Future<List<Establecimiento>> obtenerDestacados() async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('estaDestacado', isEqualTo: true)
          .orderBy('calificacionPromedio', descending: true)
          .limit(10)
          .get();
      return snapshot.docs
          .map((doc) => Establecimiento.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al obtener establecimientos destacados: $e');
      return [];
    }
  }

  /// Obtener un establecimiento por ID
  Future<Establecimiento?> obtenerPorId(String id) async {
    try {
      final doc = await _firestore.collection(_coleccion).doc(id).get();
      if (doc.exists) {
        return Establecimiento.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error al obtener establecimiento: $e');
      return null;
    }
  }

  /// Crear un nuevo establecimiento
  Future<String?> crearEstablecimiento(Establecimiento establecimiento) async {
    try {
      final docRef =
          await _firestore.collection(_coleccion).add(establecimiento.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error al crear establecimiento: $e');
      return null;
    }
  }

  /// Actualizar un establecimiento
  Future<bool> actualizarEstablecimiento(Establecimiento establecimiento) async {
    try {
      await _firestore
          .collection(_coleccion)
          .doc(establecimiento.id)
          .update(establecimiento.toFirestore());
      return true;
    } catch (e) {
      print('Error al actualizar establecimiento: $e');
      return false;
    }
  }

  /// Eliminar un establecimiento
  Future<bool> eliminarEstablecimiento(String id) async {
    try {
      await _firestore.collection(_coleccion).doc(id).delete();
      return true;
    } catch (e) {
      print('Error al eliminar establecimiento: $e');
      return false;
    }
  }

  /// Actualizar calificación promedio
  Future<bool> actualizarCalificacion(
    String id,
    double nuevaCalificacion,
    int nuevoTotal,
  ) async {
    try {
      await _firestore.collection(_coleccion).doc(id).update({
        'calificacionPromedio': nuevaCalificacion,
        'totalResenas': nuevoTotal,
      });
      return true;
    } catch (e) {
      print('Error al actualizar calificación: $e');
      return false;
    }
  }

  /// Stream de establecimientos (actualización en tiempo real)
  Stream<List<Establecimiento>> obtenerStreamTodos() {
    return _firestore.collection(_coleccion).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Establecimiento.fromFirestore(doc))
            .toList());
  }

  /// Buscar establecimientos por nombre
  Future<List<Establecimiento>> buscar(String termino) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('nombre', isGreaterThanOrEqualTo: termino)
          .where('nombre', isLessThan: termino + 'z')
          .get();
      return snapshot.docs
          .map((doc) => Establecimiento.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al buscar establecimientos: $e');
      return [];
    }
  }
}
