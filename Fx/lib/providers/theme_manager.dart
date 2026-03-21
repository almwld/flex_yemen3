import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// مدير الثيم - يتحكم في الوضع الداكن/الفاتح
class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';
  
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  ThemeManager() {
    _loadTheme();
  }

  /// تحميل الثيم المحفوظ
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  /// تبديل الثيم
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// تعيين الثيم مباشرة
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    
    _isDarkMode = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// الحصول على الثيم الحالي
  ThemeData get currentTheme {
    return _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  /// الحصول على لون النص المناسب
  Color getTextColor(BuildContext context) {
    return AppTheme.getTextColor(context);
  }

  /// الحصول على لون الخلفية المناسب
  Color getBackgroundColor(BuildContext context) {
    return AppTheme.getBackgroundColor(context);
  }

  /// الحصول على لون البطاقة المناسب
  Color getCardColor(BuildContext context) {
    return AppTheme.getCardColor(context);
  }
}
