import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para Rutas de Transporte Público
class RutaTransporte {
  final String id;
  final String nombre;
  final String operador; // Empresa de transporte
  final String numeroRuta;
  final String descripcion;
  final List<Parada> paradas; // Puntos de parada
  final List<LatLng> coordenadas; // Polyline del recorrido
  final String color; // Color del marcador en el mapa
  final String horarioInicio;
  final String horarioFin;
  final double tarifa;
  final String moneda;
  final bool estaActiva;
  final DateTime fechaCreacion;

  RutaTransporte({
    required this.id,
    required this.nombre,
    required this.operador,
    required this.numeroRuta,
    required this.descripcion,
    required this.paradas,
    required this.coordenadas,
    required this.color,
    required this.horarioInicio,
    required this.horarioFin,
    required this.tarifa,
    required this.moneda,
    this.estaActiva = true,
    required this.fechaCreacion,
  });

  /// Convertir de Firestore a Dart
  factory RutaTransporte.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RutaTransporte(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      operador: data['operador'] ?? '',
      numeroRuta: data['numeroRuta'] ?? '',
      descripcion: data['descripcion'] ?? '',
      paradas: (data['paradas'] as List<dynamic>?)
          ?.map((p) => Parada.fromMap(p as Map<String, dynamic>))
          .toList() ?? [],
      coordenadas: (data['coordenadas'] as List<dynamic>?)
          ?.map((c) => LatLng.fromMap(c as Map<String, dynamic>))
          .toList() ?? [],
      color: data['color'] ?? '#FF0000',
      horarioInicio: data['horarioInicio'] ?? '06:00',
      horarioFin: data['horarioFin'] ?? '22:00',
      tarifa: (data['tarifa'] ?? 13.0).toDouble(),
      moneda: data['moneda'] ?? 'MXN',
      estaActiva: data['estaActiva'] ?? true,
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
    );
  }

  /// Convertir de Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'operador': operador,
      'numeroRuta': numeroRuta,
      'descripcion': descripcion,
      'paradas': paradas.map((p) => p.toMap()).toList(),
      'coordenadas': coordenadas.map((c) => c.toMap()).toList(),
      'color': color,
      'horarioInicio': horarioInicio,
      'horarioFin': horarioFin,
      'tarifa': tarifa,
      'moneda': moneda,
      'estaActiva': estaActiva,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
    };
  }
}

/// Modelo para Parada de Transporte
class Parada {
  final String nombre;
  final double latitud;
  final double longitud;
  final int numeroOrden; // Orden en el recorrido

  Parada({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.numeroOrden,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'latitud': latitud,
      'longitud': longitud,
      'numeroOrden': numeroOrden,
    };
  }

  factory Parada.fromMap(Map<String, dynamic> map) {
    return Parada(
      nombre: map['nombre'] ?? '',
      latitud: (map['latitud'] ?? 0.0).toDouble(),
      longitud: (map['longitud'] ?? 0.0).toDouble(),
      numeroOrden: map['numeroOrden'] ?? 0,
    );
  }
}

/// Modelo para coordenadas (Lat/Lng)
class LatLng {
  final double latitud;
  final double longitud;

  LatLng({
    required this.latitud,
    required this.longitud,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitud': latitud,
      'longitud': longitud,
    };
  }

  factory LatLng.fromMap(Map<String, dynamic> map) {
    return LatLng(
      latitud: (map['latitud'] ?? 0.0).toDouble(),
      longitud: (map['longitud'] ?? 0.0).toDouble(),
    );
  }
}
