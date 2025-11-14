import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para Usuario
class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String? fotoPerfil;
  final String? telefono;
  final DateTime fechaCreacion;
  final List<String> establecimientosGuardados; // IDs de establecimientos favoritos
  final Map<String, dynamic> preferencias; // Configuraciones del usuario

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    this.fotoPerfil,
    this.telefono,
    required this.fechaCreacion,
    this.establecimientosGuardados = const [],
    this.preferencias = const {},
  });

  /// Convertir de Firestore a Dart
  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      fotoPerfil: data['fotoPerfil'],
      telefono: data['telefono'],
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      establecimientosGuardados: List<String>.from(data['establecimientosGuardados'] ?? []),
      preferencias: data['preferencias'] ?? {},
    );
  }

  /// Convertir de Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'email': email,
      'fotoPerfil': fotoPerfil,
      'telefono': telefono,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'establecimientosGuardados': establecimientosGuardados,
      'preferencias': preferencias,
    };
  }

  Usuario copyWith({
    String? id,
    String? nombre,
    String? email,
    String? fotoPerfil,
    String? telefono,
    DateTime? fechaCreacion,
    List<String>? establecimientosGuardados,
    Map<String, dynamic>? preferencias,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      telefono: telefono ?? this.telefono,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      establecimientosGuardados: establecimientosGuardados ?? this.establecimientosGuardados,
      preferencias: preferencias ?? this.preferencias,
    );
  }
}
