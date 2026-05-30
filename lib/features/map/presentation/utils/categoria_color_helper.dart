import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CategoriaColorHelper {
  static Color getColor(String categoria) {
    final c = categoria.trim().toLowerCase();

    if (c == 'exposicions') return Colors.red;
    if (c == 'infantil') return Colors.pinkAccent;
    if (c == 'teatre') return Colors.amber;
    if (c == 'concerts') return Colors.green;
    if (c == 'festes') return Colors.deepOrange;
    if (c == 'festivals i mostres') return Colors.purple;
    if (c == 'conferencies') return Colors.cyan;
    if (c == 'rutes i visites') return Colors.blue;
    if (c == 'altres') return Colors.indigo;

    return Colors.indigo;
  }

  static double getHue(String categoria) {
    final color = getColor(categoria);

    if (color == Colors.red) return BitmapDescriptor.hueRed;
    if (color == Colors.pinkAccent) return BitmapDescriptor.hueRose;
    if (color == Colors.amber) return BitmapDescriptor.hueYellow;
    if (color == Colors.green) return BitmapDescriptor.hueGreen;
    if (color == Colors.deepOrange) return BitmapDescriptor.hueOrange;
    if (color == Colors.purple) return BitmapDescriptor.hueViolet;
    if (color == Colors.cyan) return BitmapDescriptor.hueCyan;
    if (color == Colors.blue) return BitmapDescriptor.hueAzure;
    if (color == Colors.indigo) return BitmapDescriptor.hueBlue;

    return BitmapDescriptor.hueBlue;
  }
}