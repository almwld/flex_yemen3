import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// خدمة الموقع الجغرافي
class LocationService {
  /// التحقق من صلاحيات الموقع
  static Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // التحقق من تفعيل خدمة الموقع
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return false;
    }

    // التحقق من صلاحيات الموقع
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  /// الحصول على الموقع الحالي
  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  /// الحصول على آخر موقع معروف
  static Future<Position?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      return position;
    } catch (e) {
      debugPrint('Error getting last known location: $e');
      return null;
    }
  }

  /// الحصول على العنوان من الإحداثيات
  static Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first;
      final addressParts = <String>[];

      if (placemark.subLocality?.isNotEmpty == true) {
        addressParts.add(placemark.subLocality!);
      }
      if (placemark.locality?.isNotEmpty == true) {
        addressParts.add(placemark.locality!);
      }
      if (placemark.administrativeArea?.isNotEmpty == true) {
        addressParts.add(placemark.administrativeArea!);
      }

      return addressParts.join(', ');
    } catch (e) {
      debugPrint('Error getting address: $e');
      return null;
    }
  }

  /// الحصول على المدينة من الإحداثيات
  static Future<String?> getCityFromLatLng(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;

      return placemarks.first.locality;
    } catch (e) {
      debugPrint('Error getting city: $e');
      return null;
    }
  }

  /// الحصول على الإحداثيات من العنوان
  static Future<Location?> getLatLngFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isEmpty) return null;

      return locations.first;
    } catch (e) {
      debugPrint('Error getting coordinates from address: $e');
      return null;
    }
  }

  /// متابعة تغييرات الموقع
  static Stream<Position>? getLocationStream() {
    try {
      return Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100, // تحديث كل 100 متر
        ),
      );
    } catch (e) {
      debugPrint('Error getting location stream: $e');
      return null;
    }
  }

  /// حساب المسافة بين نقطتين
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// فتح إعدادات الموقع
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// فتح إعدادات التطبيق
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// قائمة المدن اليمنية الرئيسية
  static const List<String> yemeniCities = [
    'صنعاء',
    'عدن',
    'تعز',
    'الحديدة',
    'المكلا',
    'إب',
    'ذمار',
    'البيضاء',
    'سيئون',
    'زبيد',
    'ريمة',
    'عمران',
    'حجة',
    'صعدة',
    'المحويت',
    'لحج',
    'أبين',
    'شبوة',
    'المهرة',
    'سقطرى',
    'الجوف',
    'مأرب',
    'الضالع',
    'حضرموت',
  ];

  /// الحصول على المدن
  static List<String> getCities() {
    return yemeniCities;
  }

  /// البحث في المدن
  static List<String> searchCities(String query) {
    if (query.isEmpty) return yemeniCities;
    
    return yemeniCities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
