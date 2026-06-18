import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NominatimService {
  const NominatimService({http.Client? client}) : _client = client;

  final http.Client? _client;

  http.Client get client => _client ?? http.Client();

  Future<LatLng> searchLocation(String query) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'json',
      'limit': '1',
    });
    final response = await client.get(uri, headers: const {
      'User-Agent': 'Re-kollect Flutter MVP',
    });
    if (response.statusCode != 200) {
      throw Exception('OpenStreetMap location lookup failed.');
    }
    final results = jsonDecode(response.body) as List<dynamic>;
    if (results.isEmpty) {
      throw Exception('No OpenStreetMap result found for that location.');
    }
    final first = results.first as Map<String, dynamic>;
    return LatLng(
      double.parse(first['lat'] as String),
      double.parse(first['lon'] as String),
    );
  }

  Future<String> reverseLocation(LatLng point) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'lat': point.latitude.toString(),
      'lon': point.longitude.toString(),
      'format': 'json',
    });
    final response = await client.get(uri, headers: const {
      'User-Agent': 'Re-kollect Flutter MVP',
    });
    if (response.statusCode != 200) {
      throw Exception('OpenStreetMap reverse lookup failed.');
    }
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    return result['display_name'] as String? ?? '${point.latitude}, ${point.longitude}';
  }
}
