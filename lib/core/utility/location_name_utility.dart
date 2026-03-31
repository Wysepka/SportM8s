import 'package:geocoding/geocoding.dart';

class LocationNameUtility{
  static String getBestDisplayNameFromPlacemarks(List<Placemark> placemarks) {
    if (placemarks.isEmpty) {
      return 'Unknown place';
    }

    final List<_Candidate> candidates = [];

    for (final p in placemarks) {
      // Best possible labels first
      _addCandidate(candidates, p.name, 100, CandidateType.name);
      _addCandidate(candidates, p.subLocality, 90, CandidateType.subLocality);
      _addCandidate(candidates, p.locality, 80, CandidateType.locality);

      // Street alone is usually nicer than street with number embedded in name
      _addCandidate(candidates, p.street, 70, CandidateType.street);

      _addCandidate(candidates, p.subAdministrativeArea, 50, CandidateType.subAdministrativeArea);
      _addCandidate(candidates, p.administrativeArea, 40, CandidateType.administrativeArea);
      _addCandidate(candidates, p.country, 20, CandidateType.country);
    }

    if (candidates.isEmpty) {
      return 'Unknown place';
    }

    // Merge duplicates keeping the best score
    final Map<String, _Candidate> bestByNormalized = {};
    for (final c in candidates) {
      final existing = bestByNormalized[c.normalized];
      if (existing == null || c.score > existing.score) {
        bestByNormalized[c.normalized] = c;
      }
    }

    final sorted = bestByNormalized.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return sorted.first.original;
  }

  static void _addCandidate(
      List<_Candidate> output,
      String? rawValue,
      int baseScore,
      CandidateType type,
      ) {
    final value = _normalize(rawValue);
    if (value == null) return;

    if (_isBadCandidate(value)) return;

    int score = baseScore;

    if (_isOnlyNumber(value)) score -= 100;
    if(_looksLikeHouseNumber(value)) score -= 100;
    if (_containsManyDigits(value)) score -= 25;
    if (_looksLikePostalCode(value)) score -= 80;
    if (_isGenericAdministrativeName(value)) score -= 20;

    // Reward attractive human-readable names
    if (_looksLikeNicePoiName(value)) score += 15;

    // If street contains number, prefer it less than clean street name
    if (type == CandidateType.street && _containsAnyDigit(value)) {
      score -= 15;
    }

    if (score <= 0) return;

    output.add(_Candidate(
      original: value,
      normalized: value.toLowerCase(),
      score: score,
      type: type,
    ));
  }

  static String? _normalize(String? value) {
    if (value == null) return null;
    final trimmed = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    return trimmed.isEmpty ? null : trimmed;
  }

  static bool _isBadCandidate(String value) {
    if (value.isEmpty) return true;
    if(_looksLikeHouseNumber(value)) return true;
    if (_isOnlyNumber(value)) return true;
    if (_looksLikePostalCode(value)) return true;
    return false;
  }

  static bool _looksLikeHouseNumber(String value) {
    final v = value.trim().toLowerCase();

    return RegExp(r'^\d{1,3}[a-z]{0,3}$').hasMatch(v) ||
        RegExp(r'^\d{1,3}/\d{1,3}[a-z]{0,3}$').hasMatch(v) ||
        RegExp(r'^\d{1,3}-\d{1,3}[a-z]{0,3}$').hasMatch(v);
  }

  static bool _isOnlyNumber(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  static bool _containsAnyDigit(String value) {
    return RegExp(r'\d').hasMatch(value);
  }

  static bool _containsManyDigits(String value) {
    final digitCount = RegExp(r'\d').allMatches(value).length;
    return digitCount >= 3;
  }

  static bool _looksLikePostalCode(String value) {
    return RegExp(r'^\d{2}-\d{3}$').hasMatch(value);
  }

  static bool _isGenericAdministrativeName(String value) {
    final lower = value.toLowerCase();

    return lower.startsWith('województwo') ||
        lower.startsWith('powiat') ||
        lower.startsWith('gmina') ||
        lower == 'mazowieckie' ||
        lower == 'polska' ||
        lower == 'poland';
  }

  static bool _looksLikeNicePoiName(String value) {
    final lower = value.toLowerCase();

    // Heuristic: contains letters, not mostly digits, and is not overly generic
    if (_containsManyDigits(value)) return false;
    if (lower == 'polska' || lower == 'poland') return false;
    if (lower.startsWith('województwo')) return false;
    return RegExp(r'[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]').hasMatch(value);
  }

  static String getBestShortDisplayName(List<Placemark> placemarks) {
    final primary = getBestDisplayNameFromPlacemarks(placemarks);

    final locality = placemarks
        .map((p) => p.subLocality?.trim())
        .followedBy(placemarks.map((p) => p.locality?.trim()))
        .whereType<String>()
        .firstWhere(
          (e) => e.isNotEmpty && e.toLowerCase() != primary.toLowerCase(),
      orElse: () => '',
    );

    if (locality.isNotEmpty &&
        !_containsAnyDigit(primary) &&
        primary.toLowerCase() != locality.toLowerCase()) {
      return '$primary, $locality';
    }

    return primary;
  }
}

enum CandidateType {
  name,
  subLocality,
  locality,
  street,
  subAdministrativeArea,
  administrativeArea,
  country,
}

class _Candidate {
  final String original;
  final String normalized;
  final int score;
  final CandidateType type;

  _Candidate({
    required this.original,
    required this.normalized,
    required this.score,
    required this.type,
  });
}