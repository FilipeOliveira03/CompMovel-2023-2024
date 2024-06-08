import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../classes/Lote.dart';
import '../repository/ParquesRepository.dart';
import 'DetalheParque.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  List<Lote> minhaListaParques = [];
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pLisboa = LatLng(38.7223, -9.1393);
  LatLng? _currentP = null;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    fetchData();
  }

  Future<void> fetchData() async {
    final parquesRepository = context.read<ParquesRepository>();
    minhaListaParques = await parquesRepository.getLots();
    setState(() {
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    Set<Marker> newMarkers = {};

    if (_currentP != null) {
      newMarkers.add(
        Marker(
          markerId: MarkerId('_currentLocation'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: _currentP ?? _pLisboa,
        ),
      );
    }

    for (var parque in minhaListaParques) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(parque.nome),
          position: LatLng(
              double.parse(parque.latitude), double.parse(parque.longitude)),
          infoWindow: InfoWindow(
            title: parque.nome,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalheParque(lote: parque),
              ),
            );
          },
        ),
      );
    }

    _markers = newMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
              onMapCreated: (GoogleMapController controller) =>
                  _mapController.complete(controller),
              initialCameraPosition: CameraPosition(
                target: _pLisboa,
                zoom: 13,
              ),
              markers: _markers,
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          for (var parque in minhaListaParques) {
            parque.distancia = Geolocator.distanceBetween(
              _currentP!.latitude,
              _currentP!.longitude,
              double.parse(parque.latitude),
              double.parse(parque.longitude),
            );
          }
          _updateMarkers();
          _cameraToPosition(_currentP!);
        });
      }
    });
  }
}
