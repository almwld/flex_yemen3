import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// خدمة التخزين المحلي باستخدام Hive
class LocalStorageService {
  static late Box _box;
  static bool _initialized = false;

  /// تهيئة Hive
  static Future<void> init() async {
    if (_initialized) return;
    
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox('flex_yemen_cache');
      _initialized = true;
      debugPrint('LocalStorageService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing LocalStorageService: $e');
    }
  }

  /// حفظ قيمة
  static Future<void> setString(String key, String value) async {
    await _ensureInitialized();
    await _box.put(key, value);
  }

  /// الحصول على قيمة نصية
  static String? getString(String key) {
    _ensureInitialized();
    return _box.get(key) as String?;
  }

  /// حفظ قيمة منطقية
  static Future<void> setBool(String key, bool value) async {
    await _ensureInitialized();
    await _box.put(key, value);
  }

  /// الحصول على قيمة منطقية
  static bool getBool(String key, {bool defaultValue = false}) {
    _ensureInitialized();
    return _box.get(key) as bool? ?? defaultValue;
  }

  /// حفظ عدد صحيح
  static Future<void> setInt(String key, int value) async {
    await _ensureInitialized();
    await _box.put(key, value);
  }

  /// الحصول على عدد صحيح
  static int getInt(String key, {int defaultValue = 0}) {
    _ensureInitialized();
    return _box.get(key) as int? ?? defaultValue;
  }

  /// حفظ عدد عشري
  static Future<void> setDouble(String key, double value) async {
    await _ensureInitialized();
    await _box.put(key, value);
  }

  /// الحصول على عدد عشري
  static double getDouble(String key, {double defaultValue = 0.0}) {
    _ensureInitialized();
    return _box.get(key) as double? ?? defaultValue;
  }

  /// حفظ قائمة
  static Future<void> setStringList(String key, List<String> value) async {
    await _ensureInitialized();
    await _box.put(key, value);
  }

  /// الحصول على قائمة
  static List<String> getStringList(String key) {
    _ensureInitialized();
    final value = _box.get(key);
    if (value == null) return [];
    return List<String>.from(value);
  }

  /// حفظ كائن JSON
  static Future<void> setJson(String key, Map<String, dynamic> value) async {
    await _ensureInitialized();
    await _box.put(key, jsonEncode(value));
  }

  /// الحصول على كائن JSON
  static Map<String, dynamic>? getJson(String key) {
    _ensureInitialized();
    final value = _box.get(key) as String?;
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error parsing JSON: $e');
      return null;
    }
  }

  /// حفظ قائمة كائنات JSON
  static Future<void> setJsonList(String key, List<Map<String, dynamic>> value) async {
    await _ensureInitialized();
    await _box.put(key, jsonEncode(value));
  }

  /// الحصول على قائمة كائنات JSON
  static List<Map<String, dynamic>> getJsonList(String key) {
    _ensureInitialized();
    final value = _box.get(key) as String?;
    if (value == null) return [];
    try {
      final list = jsonDecode(value) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error parsing JSON list: $e');
      return [];
    }
  }

  /// حذف قيمة
  static Future<void> remove(String key) async {
    await _ensureInitialized();
    await _box.delete(key);
  }

  /// حذف جميع القيم
  static Future<void> clear() async {
    await _ensureInitialized();
    await _box.clear();
  }

  /// التحقق من وجود مفتاح
  static bool containsKey(String key) {
    _ensureInitialized();
    return _box.containsKey(key);
  }

  /// الحصول على جميع المفاتيح
  static Iterable<String> getKeys() {
    _ensureInitialized();
    return _box.keys.cast<String>();
  }

  /// التأكد من التهيئة
  static void _ensureInitialized() {
    if (!_initialized) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
  }

  // ==================== دوال مساعدة محددة ====================

  /// حفظ المنتجات المفضلة محلياً
  static Future<void> cacheFavorites(List<String> productIds) async {
    await setStringList('cached_favorites', productIds);
  }

  /// الحصول على المنتجات المفضلة المخزنة محلياً
  static List<String> getCachedFavorites() {
    return getStringList('cached_favorites');
  }

  /// حفظ سجل البحث
  static Future<void> addSearchHistory(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 10) {
        history.removeLast();
      }
      await setStringList('search_history', history);
    }
  }

  /// الحصول على سجل البحث
  static List<String> getSearchHistory() {
    return getStringList('search_history');
  }

  /// مسح سجل البحث
  static Future<void> clearSearchHistory() async {
    await remove('search_history');
  }

  /// حفظ بيانات المستخدم مؤقتاً
  static Future<void> cacheUserData(Map<String, dynamic> userData) async {
    await setJson('cached_user_data', userData);
  }

  /// الحصول على بيانات المستخدم المخزنة
  static Map<String, dynamic>? getCachedUserData() {
    return getJson('cached_user_data');
  }

  /// حفظ إعدادات التطبيق
  static Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    await setJson('app_settings', settings);
  }

  /// الحصول على إعدادات التطبيق
  static Map<String, dynamic> getAppSettings() {
    return getJson('app_settings') ?? {};
  }

  /// حفظ المنتجات المخزنة مؤقتاً
  static Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    await setJsonList('cached_products', products);
    await setInt('cached_products_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  /// الحصول على المنتجات المخزنة مؤقتاً
  static List<Map<String, dynamic>> getCachedProducts() {
    return getJsonList('cached_products');
  }

  /// التحقق من صلاحية الكاش
  static bool isCacheValid(String key, {int maxAgeMinutes = 60}) {
    final timestamp = getInt('${key}_timestamp');
    if (timestamp == 0) return false;
    
    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    return age < (maxAgeMinutes * 60 * 1000);
  }

  /// حفظ إعدادات الإشعارات
  static Future<void> saveNotificationSettings({
    bool allEnabled = true,
    bool ordersEnabled = true,
    bool messagesEnabled = true,
    bool offersEnabled = true,
  }) async {
    await setJson('notification_settings', {
      'all': allEnabled,
      'orders': ordersEnabled,
      'messages': messagesEnabled,
      'offers': offersEnabled,
    });
  }

  /// الحصول على إعدادات الإشعارات
  static Map<String, bool> getNotificationSettings() {
    final settings = getJson('notification_settings');
    return {
      'all': settings?['all'] ?? true,
      'orders': settings?['orders'] ?? true,
      'messages': settings?['messages'] ?? true,
      'offers': settings?['offers'] ?? true,
    };
  }

  /// إغلاق الصندوق
  static Future<void> close() async {
    if (_initialized) {
      await _box.close();
      _initialized = false;
    }
  }
}
