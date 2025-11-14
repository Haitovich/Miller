import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

/// Servicio para gestionar Reseñas en Firestore
class ResenaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _coleccion = 'resenas';
  final String _coleccionEstablecimientos = 'establecimientos';

  /// Obtener todas las reseñas de un establecimiento
  Future<List<Resena>> obtenerResenasPorEstablecimiento(
    String establecimientoId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('establecimientoId', isEqualTo: establecimientoId)
          .orderBy('fechaCreacion', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Resena.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al obtener reseñas: $e');
      return [];
    }
  }

  /// Agregar una nueva reseña
  Future<bool> agregarResena(Resena resena) async {
    try {
      // Guardar la reseña
      await _firestore.collection(_coleccion).add(resena.toFirestore());

      // Actualizar calificación promedio del establecimiento
      await _actualizarCalificacionEstablecimiento(resena.establecimientoId);

      return true;
    } catch (e) {
      print('Error al agregar reseña: $e');
      return false;
    }
  }

  /// Actualizar una reseña
  Future<bool> actualizarResena(Resena resena) async {
    try {
      await _firestore
          .collection(_coleccion)
          .doc(resena.id)
          .update(resena.toFirestore());

      // Actualizar calificación promedio del establecimiento
      await _actualizarCalificacionEstablecimiento(resena.establecimientoId);

      return true;
    } catch (e) {
      print('Error al actualizar reseña: $e');
      return false;
    }
  }

  /// Eliminar una reseña
  Future<bool> eliminarResena(String resenaId, String establecimientoId) async {
    try {
      await _firestore.collection(_coleccion).doc(resenaId).delete();

      // Actualizar calificación promedio del establecimiento
      await _actualizarCalificacionEstablecimiento(establecimientoId);

      return true;
    } catch (e) {
      print('Error al eliminar reseña: $e');
      return false;
    }
  }

  /// Agregar like a una reseña
  Future<bool> agregarLike(String resenaId) async {
    try {
      await _firestore.collection(_coleccion).doc(resenaId).update({
        'totalLikes': FieldValue.increment(1),
      });
      return true;
    } catch (e) {
      print('Error al agregar like: $e');
      return false;
    }
  }

  /// Obtener reseñas de mejor calificación
  Future<List<Resena>> obtenerMejoresResenas(
    String establecimientoId, {
    int limite = 5,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('establecimientoId', isEqualTo: establecimientoId)
          .where('esVerificada', isEqualTo: true)
          .orderBy('calificacion', descending: true)
          .limit(limite)
          .get();

      return snapshot.docs
          .map((doc) => Resena.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error al obtener mejores reseñas: $e');
      return [];
    }
  }

  /// Stream de reseñas en tiempo real
  Stream<List<Resena>> obtenerStreamResenas(String establecimientoId) {
    return _firestore
        .collection(_coleccion)
        .where('establecimientoId', isEqualTo: establecimientoId)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Resena.fromFirestore(doc))
            .toList());
  }

  /// Actualizar calificación promedio del establecimiento
  Future<void> _actualizarCalificacionEstablecimiento(
    String establecimientoId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_coleccion)
          .where('establecimientoId', isEqualTo: establecimientoId)
          .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      double sumaCalificaciones = 0;
      for (var doc in snapshot.docs) {
        sumaCalificaciones += doc['calificacion'] ?? 0.0;
      }

      double promedio = sumaCalificaciones / snapshot.docs.length;

      await _firestore
          .collection(_coleccionEstablecimientos)
          .doc(establecimientoId)
          .update({
        'calificacionPromedio': promedio,
        'totalResenas': snapshot.docs.length,
      });
    } catch (e) {
      print('Error al actualizar calificación del establecimiento: $e');
    }
  }
}
