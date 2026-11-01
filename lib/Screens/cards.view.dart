
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class CardsView extends StatefulWidget {
  const CardsView({super.key});

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  static const LatLng casablanca = LatLng(33.5731, -7.5898);
  static const double initialZoom = 12;

  final MapController mapController = MapController();

  LatLng selectedPosition = casablanca;
  LatLng? startPosition;
  LatLng? destinationPosition;

  List<LatLng> routePoints = [];

  double zoom = initialZoom;
  double? distance;
  double? duration;
  bool isLoading = false;

  void changeZoom(double amount) {
    final newZoom = (zoom + amount).clamp(3.0, 18.0).toDouble();
    mapController.move(mapController.camera.center, newZoom);
  }

  Future<void> calculateRoute() async {
    if (startPosition == null || destinationPosition == null) return;

    setState(() {
      isLoading = true;
      routePoints = [];
      distance = null;
      duration = null;
    });

    try {
      final start = startPosition!;
      final destination = destinationPosition!;

      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Erreur lors du calcul de l’itinéraire.');
      }

      final data = jsonDecode(response.body);

      if (data['code'] != 'Ok' ||
          (data['routes'] as List).isEmpty) {
        throw Exception('Aucun itinéraire trouvé.');
      }

      final route = data['routes'][0];

      final coordinates =
          route['geometry']['coordinates'] as List;

      final points = coordinates.map<LatLng>((coordinate) {
        return LatLng(
          (coordinate[1] as num).toDouble(),
          (coordinate[0] as num).toDouble(),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        routePoints = points;
        distance = (route['distance'] as num).toDouble();
        duration = (route['duration'] as num).toDouble();
        isLoading = false;
      });

      if (points.isNotEmpty) {
        mapController.fitCamera(
          CameraFit.coordinates(
            coordinates: points,
            padding: const EdgeInsets.all(60),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de calculer le trajet : $e'),
        ),
      );
    }
  }

  void resetMap() {
    setState(() {
      selectedPosition = casablanca;
      startPosition = null;
      destinationPosition = null;
      routePoints = [];
      distance = null;
      duration = null;
      isLoading = false;
    });

    mapController.move(casablanca, initialZoom);
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: casablanca,
            initialZoom: initialZoom,
            minZoom: 3,
            maxZoom: 18,
            onTap: (tapPosition, point) {
              setState(() {
                selectedPosition = point;

                if (startPosition == null ||
                    destinationPosition != null) {
                  startPosition = point;
                  destinationPosition = null;
                  routePoints = [];
                  distance = null;
                  duration = null;
                } else {
                  destinationPosition = point;
                }
              });

              if (startPosition != null &&
                  destinationPosition != null) {
                calculateRoute();
              }
            },
            onPositionChanged: (camera, hasGesture) {
              if (zoom != camera.zoom) {
                setState(() {
                  zoom = camera.zoom;
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app_flutter',
            ),

            if (routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 5,
                    color: Colors.blue,
                  ),
                ],
              ),

            MarkerLayer(
              markers: [
                if (startPosition != null)
                  Marker(
                    point: startPosition!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),

                if (destinationPosition != null)
                  Marker(
                    point: destinationPosition!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
              ],
            ),
          ],
        ),

        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    startPosition == null
                        ? 'Touchez la carte pour choisir le départ'
                        : destinationPosition == null
                            ? 'Départ sélectionné : choisissez la destination'
                            : 'Itinéraire calculé',
                    textAlign: TextAlign.center,
                  ),

                  if (isLoading) ...[
                    const SizedBox(height: 8),
                    const CircularProgressIndicator(),
                  ],

                  if (distance != null && duration != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Distance : '
                      '${(distance! / 1000).toStringAsFixed(2)} km',
                    ),
                    Text(
                      'Durée estimée : '
                      '${(duration! / 60).ceil()} min',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        Positioned(
          right: 12,
          bottom: 12,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'zoom_in',
                onPressed: () => changeZoom(1),
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),

              FloatingActionButton.small(
                heroTag: 'zoom_out',
                onPressed: () => changeZoom(-1),
                child: const Icon(Icons.remove),
              ),
              const SizedBox(height: 8),

              FloatingActionButton.small(
                heroTag: 'reset_map',
                onPressed: resetMap,
                child: const Icon(Icons.my_location),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
