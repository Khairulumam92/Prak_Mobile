import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Request location permission
  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  // Check if location permission is granted
  Future<bool> isPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  // Get current location coordinates
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if permission is granted
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      bool permissionGranted = await isPermissionGranted();
      if (!permissionGranted) {
        permissionGranted = await requestPermission();
        if (!permissionGranted) {
          return null;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  // Get city name from coordinates
  // For demo purposes, we'll use a simple mapping based on coordinates
  // In production, you would use geocoding service
  Future<String> getCityName() async {
    try {
      final position = await getCurrentLocation();
      
      if (position == null) {
        return 'MEDAN'; // Default city
      }

      // Simple coordinate-based city detection for Indonesia
      // This is a simplified version - in production use geocoding
      final lat = position.latitude;
      final lon = position.longitude;

      // Approximate coordinates for major Indonesian cities
      if (lat >= 3.5 && lat <= 3.7 && lon >= 98.6 && lon <= 98.8) {
        return 'MEDAN';
      } else if (lat >= -6.2 && lat <= -6.1 && lon >= 106.7 && lon <= 106.9) {
        return 'JAKARTA';
      } else if (lat >= -7.3 && lat <= -7.2 && lon >= 112.6 && lon <= 112.8) {
        return 'SURABAYA';
      } else if (lat >= -6.9 && lat <= -6.8 && lon >= 107.6 && lon <= 107.7) {
        return 'BANDUNG';
      } else if (lat >= -5.2 && lat <= -5.1 && lon >= 119.4 && lon <= 119.5) {
        return 'MAKASSAR';
      } else {
        return 'MEDAN'; // Default
      }
    } catch (e) {
      return 'MEDAN'; // Default on error
    }
  }
}
