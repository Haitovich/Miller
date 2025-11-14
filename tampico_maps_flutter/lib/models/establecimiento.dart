import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para un Establecimiento (Negocio)
/// Representa una tienda, restaurante, bar, etc.
class Establecimiento {
  final String id;
  final String nombre;
  final String categoria; // tienda, restaurante, bar, mercado, taller, autolavado, inmueble
  final String descripcion;
  final double latitud;
  final double longitud;
  final String direccion;
  final String? telefono;
  final String? whatsapp;
  final String? horario;
  final List<String> fotos; // URLs de imágenes
  final List<String> menuFotos; // URLs de menús (para restaurantes)
  final double calificacionPromedio;
  final int totalResenas;
  final bool esPremium;
  final bool estaDestacado;
  final DateTime fechaCreacion;
  final Map<String, dynamic> datosAdicionales; // Para datos específicos por categoría

  Establecimiento({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.direccion,
    this.telefono,
    this.whatsapp,
    this.horario,
    this.fotos = const [],
    this.menuFotos = const [],
    this.calificacionPromedio = 0.0,
    this.totalResenas = 0,
    this.esPremium = false,
    this.estaDestacado = false,
    required this.fechaCreacion,
    this.datosAdicionales = const {},
  });

  /// Convertir de Firestore a Dart
  factory Establecimiento.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Establecimiento(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      categoria: data['categoria'] ?? '',
      descripcion: data['descripcion'] ?? '',
      latitud: (data['latitud'] ?? 0.0).toDouble(),
      longitud: (data['longitud'] ?? 0.0).toDouble(),
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'],
      whatsapp: data['whatsapp'],
      horario: data['horario'],
      fotos: List<String>.from(data['fotos'] ?? []),
      menuFotos: List<String>.from(data['menuFotos'] ?? []),
      calificacionPromedio: (data['calificacionPromedio'] ?? 0.0).toDouble(),
      totalResenas: data['totalResenas'] ?? 0,
      esPremium: data['esPremium'] ?? false,
      estaDestacado: data['estaDestacado'] ?? false,
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      datosAdicionales: data['datosAdicionales'] ?? {},
    );
  }

  /// Convertir de Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'descripcion': descripcion,
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'telefono': telefono,
      'whatsapp': whatsapp,
      'horario': horario,
      'fotos': fotos,
      'menuFotos': menuFotos,
      'calificacionPromedio': calificacionPromedio,
      'totalResenas': totalResenas,
      'esPremium': esPremium,
      'estaDestacado': estaDestacado,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'datosAdicionales': datosAdicionales,
    };
  }

  /// Copiar con cambios
  Establecimiento copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? descripcion,
    double? latitud,
    double? longitud,
    String? direccion,
    String? telefono,
    String? whatsapp,
    String? horario,
    List<String>? fotos,
    List<String>? menuFotos,
    double? calificacionPromedio,
    int? totalResenas,
    bool? esPremium,
    bool? estaDestacado,
    DateTime? fechaCreacion,
    Map<String, dynamic>? datosAdicionales,
  }) {
    return Establecimiento(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      whatsapp: whatsapp ?? this.whatsapp,
      horario: horario ?? this.horario,
      fotos: fotos ?? this.fotos,
      menuFotos: menuFotos ?? this.menuFotos,
      calificacionPromedio: calificacionPromedio ?? this.calificacionPromedio,
      totalResenas: totalResenas ?? this.totalResenas,
      esPremium: esPremium ?? this.esPremium,
      estaDestacado: estaDestacado ?? this.estaDestacado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      datosAdicionales: datosAdicionales ?? this.datosAdicionales,
    );
  }
}
