import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/sphere_style.dart';
import 'package:forty_two_planet/data/cities_coordinates.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class LoginGlobe extends StatefulWidget {
  const LoginGlobe({super.key});

  @override
  State<LoginGlobe> createState() => _LoginGlobeState();
}

class _LoginGlobeState extends State<LoginGlobe> {
  late FlutterEarthGlobeController _controller;

  @override
  initState() {
    super.initState();
    List<Point> points = cities.entries.map((entry) {
      return Point(
        id: entry.key,
        coordinates: entry.value,
        isLabelVisible: true,
        labelBuilder: (context, point, isHovering, isVisible) => Container(
          height: 2,
          width: 2,
          decoration: const BoxDecoration(
            color: ui.Color.fromARGB(255, 0, 255, 251),
          ),
        ),
        style: const PointStyle(color: Colors.transparent, size: 0),
      );
    }).toList();
    _initializeController();
    for (var point in points) {
      _controller.addPoint(point);
    }
    _controller.sphereStyle = const SphereStyle(showShadow: false);
  }

  void _initializeController() {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    _controller = FlutterEarthGlobeController(
      isRotating: true,
      rotationSpeed: -0.02,
      minZoom: 1,
      isZoomEnabled: false,
      isBackgroundFollowingSphereRotation: true,
      surface: Image.asset(
        settingsProvider.isDarkMode
            ? 'assets/images/earth_dark.png'
            : 'assets/images/earth_light.png',
      ).image,
    );
  }

  @override
  void dispose() {
    for (var point in cities.entries) {
      _controller.removePoint(point.key);
    }
    try {
      _controller.dispose();
    } catch (e) {
      debugPrint('Dispose error: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEarthGlobe(
        radius: Layout.screenWidth / 3, controller: _controller);
  }
}
