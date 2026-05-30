import 'package:flutter/material.dart';

class CategoriaIconHelper {
  static IconData getIcon(String categoria) {
    final c = categoria.trim().toLowerCase();

    if (c == 'exposicions') return Icons.palette_outlined;
    if (c == 'infantil') return Icons.child_care_outlined;
    if (c == 'teatre') return Icons.theater_comedy_outlined;
    if (c == 'concerts') return Icons.music_note_outlined;
    if (c == 'festes') return Icons.celebration_outlined;
    if (c == 'festivals i mostres') return Icons.festival_outlined;
    if (c == 'conferencies') return Icons.mic_none_outlined;
    if (c == 'rutes i visites') return Icons.map_outlined;
    if (c == 'altres') return Icons.category_outlined;

    return Icons.label_outline;
  }
}