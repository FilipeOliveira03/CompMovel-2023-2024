import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../classes/Lote.dart';
import '../classes/ParquesRepository.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  List<Lote> minhaListaParques = [];
  Location _locationController = new Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP = null;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    fetchData();
  }

  Future<void> fetchData() async {
    final parquesRepository = Provider.of<ParquesRepository>(context, listen: false);
    minhaListaParques = await parquesRepository.getLots();
    setState(() {
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    Set<Marker> newMarkers = {
      Marker(
        markerId: MarkerId('_currentLocation'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: _currentP ?? _pGooglePlex,
      ),
    };

    for (var parque in minhaListaParques) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(parque.nome),
          position: LatLng(double.parse(parque.latitude), double.parse(parque.longitude)),
          infoWindow: InfoWindow(
            title: parque.nome,
          ),
        ),
      );
    }

    _markers = newMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
        child: Text("Loading..."),
      )
          : GoogleMap(
        onMapCreated: (GoogleMapController controller) => _mapController.complete(controller),
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex,
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

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _updateMarkers();
          _cameraToPosition(_currentP!);
        });
      }
    });
  }
}
