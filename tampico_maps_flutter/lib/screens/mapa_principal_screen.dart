import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/index.dart';
import '../services/index.dart';

/// Pantalla principal con el mapa interactivo
class MapaPrincipalScreen extends StatefulWidget {
  const MapaPrincipalScreen({Key? key}) : super(key: key);

  @override
  State<MapaPrincipalScreen> createState() => _MapaPrincipalScreenState();
}

class _MapaPrincipalScreenState extends State<MapaPrincipalScreen> {
  late GoogleMapController _mapController;
  
  // Servicios
  late EstablecimientoService _establecimientoService;
  late RutaTransporteService _rutaService;
  
  // Coordenadas iniciales (Centro de Tampico)
  static const LatLng tampicoCentro = LatLng(22.2719142, -97.8610973);
  
  // Variables de estado
  List<Establecimiento> establecimientos = [];
  List<RutaTransporte> rutas = [];
  Set<Marker> marcadores = {};
  Set<Polyline> polylines = {};
  String _filtroCategoria = 'todos';
  bool _mostrarRutas = false;

  // Categorías disponibles
  final List<String> categorias = [
    'todos',
    'tienda',
    'restaurante',
    'bar',
    'mercado',
    'taller',
    'autolavado',
    'inmueble',
  ];

  // Iconos y colores por categoría
  final Map<String, MaterialColor> coloresCategorias = {
    'tienda': Colors.red,
    'restaurante': Colors.orange,
    'bar': Colors.purple,
    'mercado': Colors.green,
    'taller': Colors.cyan,
    'autolavado': Colors.blue,
    'inmueble': Colors.brown,
  };

  @override
  void initState() {
    super.initState();
    _establecimientoService = EstablecimientoService();
    _rutaService = RutaTransporteService();
    _cargarDatos();
  }

  /// Cargar datos iniciales de Firebase
  Future<void> _cargarDatos() async {
    try {
      // Cargar establecimientos
      final listaEstablecimientos = await _establecimientoService.obtenerTodos();
      
      // Cargar rutas
      final listaRutas = await _rutaService.obtenerTodas();

      setState(() {
        establecimientos = listaEstablecimientos;
        rutas = listaRutas;
      });

      // Crear marcadores
      _crearMarcadores();
    } catch (e) {
      print('Error cargando datos: $e');
      _mostrarSnackBar('Error al cargar datos');
    }
  }

  /// Crear marcadores en el mapa
  void _crearMarcadores() {
    final nuevosMarcadores = <Marker>{};

    // Agregar marcador del centro
    nuevosMarcadores.add(
      Marker(
        markerId: const MarkerId('tampico_centro'),
        position: tampicoCentro,
        infoWindow: const InfoWindow(title: '📍 Centro de Tampico'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Filtrar establecimientos por categoría
    List<Establecimiento> establecimientosFiltered = _filtroCategoria == 'todos'
        ? establecimientos
        : establecimientos
            .where((e) => e.categoria == _filtroCategoria)
            .toList();

    // Crear marcador por cada establecimiento
    for (var est in establecimientosFiltered) {
      final color = coloresCategorias[est.categoria] ?? Colors.grey;
      
      nuevosMarcadores.add(
        Marker(
          markerId: MarkerId(est.id),
          position: LatLng(est.latitud, est.longitud),
          infoWindow: InfoWindow(
            title: est.nombre,
            snippet: est.categoria.toUpperCase(),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _obtenerColorHue(color),
          ),
          onTap: () => _mostrarDetalleEstablecimiento(est),
        ),
      );
    }

    setState(() {
      marcadores = nuevosMarcadores;
    });
  }

  /// Convertir color Material a Hue para Google Maps
  double _obtenerColorHue(MaterialColor color) {
    if (color == Colors.red) return BitmapDescriptor.hueRed;
    if (color == Colors.orange) return BitmapDescriptor.hueOrange;
    if (color == Colors.purple) return BitmapDescriptor.hueViolet;
    if (color == Colors.green) return BitmapDescriptor.hueGreen;
    if (color == Colors.cyan) return BitmapDescriptor.hueCyan;
    if (color == Colors.blue) return BitmapDescriptor.hueBlue;
    return BitmapDescriptor.hueRed;
  }

  /// Crear polylines para las rutas
  void _crearPolylines() {
    final nuevosPolylines = <Polyline>{};

    for (var ruta in rutas) {
      // Convertir coordenadas del modelo a LatLng de Google Maps
      final puntos = ruta.coordenadas
          .map((p) => LatLng(p.latitud, p.longitud))
          .toList();

      if (puntos.isNotEmpty) {
        nuevosPolylines.add(
          Polyline(
            polylineId: PolylineId(ruta.id),
            points: puntos,
            color: _hexToColor(ruta.color),
            width: 5,
            geodesic: true,
            onTap: () => _mostrarDetalleRuta(ruta),
          ),
        );
      }
    }

    setState(() {
      polylines = nuevosPolylines;
    });
  }

  /// Convertir hex color a Color
  Color _hexToColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) {
        buffer.write('ff');
        buffer.write(hexString.replaceFirst('#', ''));
      } else if (hexString.length == 8 || hexString.length == 9) {
        buffer.write(hexString.replaceFirst('#', ''));
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }

  /// Mostrar detalle de establecimiento
  void _mostrarDetalleEstablecimiento(Establecimiento establecimiento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DetalleEstablecimientoSheet(
        establecimiento: establecimiento,
      ),
    );
  }

  /// Mostrar detalle de ruta
  void _mostrarDetalleRuta(RutaTransporte ruta) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DetalleRutaSheet(ruta: ruta),
    );
  }

  /// Mostrar mensaje en pantalla
  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🗺️ Tampico Maps'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarDatos,
          ),
          IconButton(
            icon: Icon(_mostrarRutas ? Icons.directions_bus : Icons.directions),
            onPressed: () {
              setState(() {
                _mostrarRutas = !_mostrarRutas;
                if (_mostrarRutas) {
                  _crearPolylines();
                } else {
                  polylines.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mapa
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: tampicoCentro,
                zoom: 12,
              ),
              markers: marcadores,
              polylines: polylines,
            ),
          ),
          
          // Filtro de categorías
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categorias.map((categoria) {
                  final esSeleccionado = _filtroCategoria == categoria;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(categoria),
                      selected: esSeleccionado,
                      onSelected: (selected) {
                        setState(() {
                          _filtroCategoria = categoria;
                          _crearMarcadores();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a pantalla para agregar negocio
          _mostrarSnackBar('Función para agregar negocio - Por implementar');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

/// Widget para mostrar detalles del establecimiento en bottom sheet
class DetalleEstablecimientoSheet extends StatelessWidget {
  final Establecimiento establecimiento;

  const DetalleEstablecimientoSheet({
    Key? key,
    required this.establecimiento,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            establecimiento.nombre,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(establecimiento.categoria),
                            backgroundColor:
                                Colors.blue.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Calificación
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${establecimiento.calificacionPromedio.toStringAsFixed(1)} (${establecimiento.totalResenas} reseñas)',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Descripción
                if (establecimiento.descripcion.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descripción',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(establecimiento.descripcion),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Dirección
                if (establecimiento.direccion.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dirección',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Expanded(child: Text(establecimiento.direccion)),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Contacto
                if (establecimiento.telefono != null &&
                    establecimiento.telefono!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contacto',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Implementar llamada
                        },
                        icon: const Icon(Icons.phone),
                        label: Text(establecimiento.telefono ?? ''),
                      ),
                      if (establecimiento.whatsapp != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Implementar WhatsApp
                            },
                            icon: const Icon(Icons.chat),
                            label: const Text('WhatsApp'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Widget para mostrar detalles de ruta en bottom sheet
class DetalleRutaSheet extends StatelessWidget {
  final RutaTransporte ruta;

  const DetalleRutaSheet({Key? key, required this.ruta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ruta ${ruta.numeroRuta}: ${ruta.nombre}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('Operador: ${ruta.operador}'),
                Text('Horario: ${ruta.horarioInicio} - ${ruta.horarioFin}'),
                Text('Tarifa: \$${ruta.tarifa.toStringAsFixed(2)} ${ruta.moneda}'),
                const SizedBox(height: 16),
                Text(
                  'Paradas (${ruta.paradas.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ruta.paradas.length,
                  itemBuilder: (context, index) {
                    final parada = ruta.paradas[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${parada.numeroOrden}'),
                      ),
                      title: Text(parada.nombre),
                      subtitle: Text(
                        '${parada.latitud.toStringAsFixed(4)}, ${parada.longitud.toStringAsFixed(4)}',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
