import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Interactive Google Map rendered through a platform-view iframe.
/// Uses the keyless embed endpoint, so no API key is required.
class MapEmbed extends StatelessWidget {
  MapEmbed({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 11,
  }) : _viewType = 'gmap-$latitude-$longitude-$zoom' {
    if (_registered.add(_viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
        final frame = web.HTMLIFrameElement()
          ..src =
              'https://maps.google.com/maps?q=$latitude,$longitude&z=$zoom&output=embed'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allowFullscreen = true;
        return frame;
      });
    }
  }

  final double latitude;
  final double longitude;
  final int zoom;
  final String _viewType;

  static final Set<String> _registered = {};

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
