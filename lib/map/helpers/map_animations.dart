import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapAnimations {
  final MapController mapController;
  final TickerProvider vsync;

  late final AnimationController _animationController;

  LatLng? _startCenter;
  LatLng? _targetCenter;
  double? _startZoom;
  double? _targetZoom;

  MapAnimations({
    required this.mapController,
    required this.vsync,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: duration,
    );

    _animationController.addListener(_onTick);
  }

  void animateTo({
    required LatLng destination,
    required double zoom,
    Curve curve = Curves.easeInOut,
  }) {
    final camera = mapController.camera;

    _startCenter = camera.center;
    _targetCenter = destination;
    _startZoom = camera.zoom;
    _targetZoom = zoom;

    _animationController
      ..stop()
      ..reset();

    final animation = CurvedAnimation(
      parent: _animationController,
      curve: curve,
    );

    _animationController.removeListener(_onTick);
    _animationController.addListener(() {
      _onTickWithValue(animation.value);
    });

    _animationController.forward(from: 0);
  }

  void _onTick() {
    _onTickWithValue(_animationController.value);
  }

  void _onTickWithValue(double t) {
    if (_startCenter == null ||
        _targetCenter == null ||
        _startZoom == null ||
        _targetZoom == null) {
      return;
    }

    final lat = lerpDouble(
      _startCenter!.latitude,
      _targetCenter!.latitude,
      t,
    )!;

    final lng = lerpDouble(
      _startCenter!.longitude,
      _targetCenter!.longitude,
      t,
    )!;

    final zoom = lerpDouble(_startZoom!, _targetZoom!, t)!;

    mapController.move(LatLng(lat, lng), zoom);
  }

  void dispose() {
    _animationController.dispose();
  }
}