/// Codificación geohash para consultas geográficas en Firestore.
///
/// Cada evento guarda `venue.geohash`; el mapa consulta por rangos de
/// prefijo geohash para cargar solo las actividades de la zona visible.
library;

const String _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

String encodeGeohash(double latitude, double longitude, {int precision = 9}) {
  var latMin = -90.0, latMax = 90.0;
  var lonMin = -180.0, lonMax = 180.0;
  final buffer = StringBuffer();
  var isEven = true;
  var bit = 0;
  var charIndex = 0;

  while (buffer.length < precision) {
    if (isEven) {
      final mid = (lonMin + lonMax) / 2;
      if (longitude >= mid) {
        charIndex = (charIndex << 1) + 1;
        lonMin = mid;
      } else {
        charIndex = charIndex << 1;
        lonMax = mid;
      }
    } else {
      final mid = (latMin + latMax) / 2;
      if (latitude >= mid) {
        charIndex = (charIndex << 1) + 1;
        latMin = mid;
      } else {
        charIndex = charIndex << 1;
        latMax = mid;
      }
    }
    isEven = !isEven;
    if (++bit == 5) {
      buffer.write(_base32[charIndex]);
      bit = 0;
      charIndex = 0;
    }
  }
  return buffer.toString();
}
