import '../config/booxy-config.dart';

class GoogleMapsHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    final String googleKey = BooxyConfig.GOOGLE_MAPS_API_KEY;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$googleKey';
  }
}
