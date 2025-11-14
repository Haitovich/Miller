import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para Casa en Renta o Venta
class Casa {
  final String id;
  final String titulo;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String direccion;
  final String tipo; // 'renta' o 'venta'
  final double precio;
  final String moneda; // MXN, USD, etc.
  final int recamaras;
  final int banos;
  final double metrosCuadrados;
  final List<String> fotos;
  final String nombreDueno;
  final String telefonoDueno;
  final String? whatsappDueno;
  final String? correoDueno;
  final bool esPremium;
  final DateTime fechaCreacion;
  final Map<String, dynamic> caracteristicas; // garage, jardín, piscina, etc.

  Casa({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.direccion,
    required this.tipo,
    required this.precio,
    required this.moneda,
    required this.recamaras,
    required this.banos,
    required this.metrosCuadrados,
    required this.fotos,
    required this.nombreDueno,
    required this.telefonoDueno,
    this.whatsappDueno,
    this.correoDueno,
    this.esPremium = false,
    required this.fechaCreacion,
    this.caracteristicas = const {},
  });

  /// Convertir de Firestore a Dart
  factory Casa.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Casa(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      latitud: (data['latitud'] ?? 0.0).toDouble(),
      longitud: (data['longitud'] ?? 0.0).toDouble(),
      direccion: data['direccion'] ?? '',
      tipo: data['tipo'] ?? 'renta',
      precio: (data['precio'] ?? 0.0).toDouble(),
      moneda: data['moneda'] ?? 'MXN',
      recamaras: data['recamaras'] ?? 0,
      banos: data['banos'] ?? 0,
      metrosCuadrados: (data['metrosCuadrados'] ?? 0.0).toDouble(),
      fotos: List<String>.from(data['fotos'] ?? []),
      nombreDueno: data['nombreDueno'] ?? '',
      telefonoDueno: data['telefonoDueno'] ?? '',
      whatsappDueno: data['whatsappDueno'],
      correoDueno: data['correoDueno'],
      esPremium: data['esPremium'] ?? false,
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      caracteristicas: data['caracteristicas'] ?? {},
    );
  }

  /// Convertir de Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'tipo': tipo,
      'precio': precio,
      'moneda': moneda,
      'recamaras': recamaras,
      'banos': banos,
      'metrosCuadrados': metrosCuadrados,
      'fotos': fotos,
      'nombreDueno': nombreDueno,
      'telefonoDueno': telefonoDueno,
      'whatsappDueno': whatsappDueno,
      'correoDueno': correoDueno,
      'esPremium': esPremium,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'caracteristicas': caracteristicas,
    };
  }

  Casa copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    double? latitud,
    double? longitud,
    String? direccion,
    String? tipo,
    double? precio,
    String? moneda,
    int? recamaras,
    int? banos,
    double? metrosCuadrados,
    List<String>? fotos,
    String? nombreDueno,
    String? telefonoDueno,
    String? whatsappDueno,
    String? correoDueno,
    bool? esPremium,
    DateTime? fechaCreacion,
    Map<String, dynamic>? caracteristicas,
  }) {
    return Casa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      direccion: direccion ?? this.direccion,
      tipo: tipo ?? this.tipo,
      precio: precio ?? this.precio,
      moneda: moneda ?? this.moneda,
      recamaras: recamaras ?? this.recamaras,
      banos: banos ?? this.banos,
      metrosCuadrados: metrosCuadrados ?? this.metrosCuadrados,
      fotos: fotos ?? this.fotos,
      nombreDueno: nombreDueno ?? this.nombreDueno,
      telefonoDueno: telefonoDueno ?? this.telefonoDueno,
      whatsappDueno: whatsappDueno ?? this.whatsappDueno,
      correoDueno: correoDueno ?? this.correoDueno,
      esPremium: esPremium ?? this.esPremium,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      caracteristicas: caracteristicas ?? this.caracteristicas,
    );
  }
}
