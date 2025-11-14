import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para Reseñas y Calificaciones
class Resena {
  final String id;
  final String establecimientoId; // ID del establecimiento al que pertenece
  final String usuarioId; // ID del usuario que dejó la reseña
  final String nombreUsuario;
  final double calificacion; // De 1 a 5 estrellas
  final String comentario;
  final List<String> fotosPrueba; // Fotos del usuario como prueba
  final int totalLikes;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;
  final bool esVerificada; // Si comprobamos que fue cliente real

  Resena({
    required this.id,
    required this.establecimientoId,
    required this.usuarioId,
    required this.nombreUsuario,
    required this.calificacion,
    required this.comentario,
    this.fotosPrueba = const [],
    this.totalLikes = 0,
    required this.fechaCreacion,
    this.fechaActualizacion,
    this.esVerificada = false,
  });

  /// Convertir de Firestore a Dart
  factory Resena.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Resena(
      id: doc.id,
      establecimientoId: data['establecimientoId'] ?? '',
      usuarioId: data['usuarioId'] ?? '',
      nombreUsuario: data['nombreUsuario'] ?? 'Anónimo',
      calificacion: (data['calificacion'] ?? 0.0).toDouble(),
      comentario: data['comentario'] ?? '',
      fotosPrueba: List<String>.from(data['fotosPrueba'] ?? []),
      totalLikes: data['totalLikes'] ?? 0,
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      fechaActualizacion: data['fechaActualizacion'] != null 
        ? (data['fechaActualizacion'] as Timestamp).toDate() 
        : null,
      esVerificada: data['esVerificada'] ?? false,
    );
  }

  /// Convertir de Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'establecimientoId': establecimientoId,
      'usuarioId': usuarioId,
      'nombreUsuario': nombreUsuario,
      'calificacion': calificacion,
      'comentario': comentario,
      'fotosPrueba': fotosPrueba,
      'totalLikes': totalLikes,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'fechaActualizacion': fechaActualizacion != null 
        ? Timestamp.fromDate(fechaActualizacion!) 
        : null,
      'esVerificada': esVerificada,
    };
  }

  Resena copyWith({
    String? id,
    String? establecimientoId,
    String? usuarioId,
    String? nombreUsuario,
    double? calificacion,
    String? comentario,
    List<String>? fotosPrueba,
    int? totalLikes,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    bool? esVerificada,
  }) {
    return Resena(
      id: id ?? this.id,
      establecimientoId: establecimientoId ?? this.establecimientoId,
      usuarioId: usuarioId ?? this.usuarioId,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      calificacion: calificacion ?? this.calificacion,
      comentario: comentario ?? this.comentario,
      fotosPrueba: fotosPrueba ?? this.fotosPrueba,
      totalLikes: totalLikes ?? this.totalLikes,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      esVerificada: esVerificada ?? this.esVerificada,
    );
  }
}
