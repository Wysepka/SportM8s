// pubspec.yaml:
// dependencies:
//   latlong2: ^0.9.1

import 'dart:math';
import 'package:latlong2/latlong.dart';

/// Minimal country key type. Use ISO code or plain English names below.
typedef CountryKey = String;

/// Bounding box for a country: [minLat, maxLat, minLng, maxLng]
class CountryBBox {
  final double minLat, maxLat, minLng, maxLng;
  const CountryBBox(this.minLat, this.maxLat, this.minLng, this.maxLng);

  LatLng randomPoint(Random rng) {
    final lat = rng.nextDouble() * (maxLat - minLat) + minLat;
    final lng = rng.nextDouble() * (maxLng - minLng) + minLng;
    return LatLng(lat, lng);
  }
}

class LocationUtility {

  /// A curated set of European country bounding boxes (approximate, WGS84).
  /// Keys support both ISO-2 (e.g., "PL") and common names (e.g., "Poland").
  /// Add or tweak as you like.
  static final Map<CountryKey, CountryBBox> _euBBoxes = {
    // Central & Western Europe
    'PL': CountryBBox(49.00, 55.03, 14.07, 24.15),
    'Poland': CountryBBox(49.00, 55.03, 14.07, 24.15),
    'DE': CountryBBox(47.27, 55.09, 5.87, 15.04),
    'Germany': CountryBBox(47.27, 55.09, 5.87, 15.04),
    'FR': CountryBBox(41.36, 51.09, -5.14, 9.56),
    'France': CountryBBox(41.36, 51.09, -5.14, 9.56),
    'ES': CountryBBox(35.50, 44.50, -9.50, 4.50),
    'Spain': CountryBBox(35.50, 44.50, -9.50, 4.50),
    'PT': CountryBBox(36.84, 42.15, -9.50, -6.19),
    'Portugal': CountryBBox(36.84, 42.15, -9.50, -6.19),
    'IT': CountryBBox(36.60, 47.10, 6.60, 18.60),
    'Italy': CountryBBox(36.60, 47.10, 6.60, 18.60),
    'CH': CountryBBox(45.80, 47.80, 5.96, 10.49),
    'Switzerland': CountryBBox(45.80, 47.80, 5.96, 10.49),
    'AT': CountryBBox(46.36, 49.02, 9.53, 17.16),
    'Austria': CountryBBox(46.36, 49.02, 9.53, 17.16),
    'BE': CountryBBox(49.50, 51.55, 2.50, 6.40),
    'Belgium': CountryBBox(49.50, 51.55, 2.50, 6.40),
    'NL': CountryBBox(50.75, 53.70, 3.30, 7.22),
    'Netherlands': CountryBBox(50.75, 53.70, 3.30, 7.22),
    'LU': CountryBBox(49.45, 50.18, 5.73, 6.53),
    'Luxembourg': CountryBBox(49.45, 50.18, 5.73, 6.53),
    'IE': CountryBBox(51.40, 55.50, -10.70, -5.40),
    'Ireland': CountryBBox(51.40, 55.50, -10.70, -5.40),
    'GB': CountryBBox(49.90, 60.90, -8.60, 1.80),
    'United Kingdom': CountryBBox(49.90, 60.90, -8.60, 1.80),

    // Nordics & Baltics
    'NO': CountryBBox(57.98, 71.19, 4.64, 31.07),
    'Norway': CountryBBox(57.98, 71.19, 4.64, 31.07),
    'SE': CountryBBox(55.34, 69.06, 11.10, 24.17),
    'Sweden': CountryBBox(55.34, 69.06, 11.10, 24.17),
    'FI': CountryBBox(59.45, 70.09, 20.55, 31.59),
    'Finland': CountryBBox(59.45, 70.09, 20.55, 31.59),
    'DK': CountryBBox(54.55, 57.75, 8.08, 15.19),
    'Denmark': CountryBBox(54.55, 57.75, 8.08, 15.19),
    'IS': CountryBBox(63.10, 66.70, -24.50, -13.50),
    'Iceland': CountryBBox(63.10, 66.70, -24.50, -13.50),
    'EE': CountryBBox(57.47, 59.67, 21.83, 28.21),
    'Estonia': CountryBBox(57.47, 59.67, 21.83, 28.21),
    'LV': CountryBBox(55.67, 58.08, 20.97, 28.24),
    'Latvia': CountryBBox(55.67, 58.08, 20.97, 28.24),
    'LT': CountryBBox(53.90, 56.45, 20.94, 26.89),
    'Lithuania': CountryBBox(53.90, 56.45, 20.94, 26.89),

    // Central/Eastern & Balkans
    'CZ': CountryBBox(48.55, 51.06, 12.09, 18.86),
    'Czechia': CountryBBox(48.55, 51.06, 12.09, 18.86),
    'SK': CountryBBox(47.73, 49.60, 16.83, 22.57),
    'Slovakia': CountryBBox(47.73, 49.60, 16.83, 22.57),
    'HU': CountryBBox(45.74, 48.58, 16.11, 22.90),
    'Hungary': CountryBBox(45.74, 48.58, 16.11, 22.90),
    'RO': CountryBBox(43.62, 48.27, 20.26, 29.68),
    'Romania': CountryBBox(43.62, 48.27, 20.26, 29.68),
    'BG': CountryBBox(41.24, 44.23, 22.36, 28.61),
    'Bulgaria': CountryBBox(41.24, 44.23, 22.36, 28.61),
    'GR': CountryBBox(34.80, 41.70, 19.60, 28.20),
    'Greece': CountryBBox(34.80, 41.70, 19.60, 28.20),
    'SI': CountryBBox(45.42, 46.88, 13.38, 16.61),
    'Slovenia': CountryBBox(45.42, 46.88, 13.38, 16.61),
    'HR': CountryBBox(42.40, 46.55, 13.49, 19.45),
    'Croatia': CountryBBox(42.40, 46.55, 13.49, 19.45),
    'BA': CountryBBox(42.56, 45.28, 15.73, 19.62),
    'Bosnia and Herzegovina': CountryBBox(42.56, 45.28, 15.73, 19.62),
    'RS': CountryBBox(42.23, 46.18, 18.82, 23.01),
    'Serbia': CountryBBox(42.23, 46.18, 18.82, 23.01),
    'ME': CountryBBox(41.85, 43.57, 18.43, 20.36),
    'Montenegro': CountryBBox(41.85, 43.57, 18.43, 20.36),
    'MK': CountryBBox(40.85, 42.36, 20.46, 23.03),
    'North Macedonia': CountryBBox(40.85, 42.36, 20.46, 23.03),
    'AL': CountryBBox(39.64, 42.66, 19.28, 21.05),
    'Albania': CountryBBox(39.64, 42.66, 19.28, 21.05),
    'XK': CountryBBox(41.85, 43.27, 20.03, 21.80),
    'Kosovo': CountryBBox(41.85, 43.27, 20.03, 21.80),

    // Eastern fringe
    'UA': CountryBBox(44.39, 52.38, 22.14, 40.23),
    'Ukraine': CountryBBox(44.39, 52.38, 22.14, 40.23),
    'BY': CountryBBox(51.26, 56.17, 23.18, 32.77),
    'Belarus': CountryBBox(51.26, 56.17, 23.18, 32.77),
    'MD': CountryBBox(45.47, 48.49, 26.62, 30.16),
    'Moldova': CountryBBox(45.47, 48.49, 26.62, 30.16),

    // Microstates & islands
    'AD': CountryBBox(42.43, 42.66, 1.41, 1.79),
    'Andorra': CountryBBox(42.43, 42.66, 1.41, 1.79),
    'MC': CountryBBox(43.72, 43.75, 7.41, 7.44),
    'Monaco': CountryBBox(43.72, 43.75, 7.41, 7.44),
    'SM': CountryBBox(43.90, 43.99, 12.40, 12.49),
    'San Marino': CountryBBox(43.90, 43.99, 12.40, 12.49),
    'LI': CountryBBox(47.05, 47.27, 9.47, 9.63),
    'Liechtenstein': CountryBBox(47.05, 47.27, 9.47, 9.63),
    'MT': CountryBBox(35.79, 36.08, 14.18, 14.68),
    'Malta': CountryBBox(35.79, 36.08, 14.18, 14.68),
    'CY': CountryBBox(34.55, 35.69, 32.27, 34.60),
    'Cyprus': CountryBBox(34.55, 35.69, 32.27, 34.60),
  };

  /// Returns a random LatLng inside the bbox of [countryKey].
  /// [countryKey] can be an ISO-2 code ('PL') or common name ('Poland') as listed above.
  /// Optionally pass a [seed] for reproducible results.
  static LatLng randomLatLngInEuropeCountry(String countryKey, {int? seed}) {
    final bbox = _euBBoxes[countryKey] ?? _euBBoxes[_titleCase(countryKey)];
    if (bbox == null) {
      throw ArgumentError(
          'Unsupported country "$countryKey". Add its bbox to _euBBoxes.');
    }
    final rng = (seed == null) ? Random() : Random(seed);
    return bbox.randomPoint(rng);
  }

  static String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  /// Example: generate N random points in Poland
  static List<LatLng> sampleInPoland(int n, {int? seed}) {
    final rng = (seed == null) ? Random() : Random(seed);
    final bbox = _euBBoxes['PL']!;
    return List<LatLng>.generate(n, (_) => bbox.randomPoint(rng));
  }
}