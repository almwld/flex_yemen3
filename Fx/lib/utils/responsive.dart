import 'package:flutter/material.dart';

/// أدوات التصميم المتجاوب
class Responsive {
  /// الحصول على عرض الشاشة
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// الحصول على ارتفاع الشاشة
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// الحصول على حجم الشاشة
  static Size size(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// التحقق من أن الشاشة صغيرة (هاتف)
  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  /// التحقق من أن الشاشة متوسطة (تابلت)
  static bool isTablet(BuildContext context) {
    return width(context) >= 600 && width(context) < 1200;
  }

  /// التحقق من أن الشاشة كبيرة (ديسكتوب)
  static static bool isDesktop(BuildContext context) {
    return width(context) >= 1200;
  }

  /// الحصول على حجم مناسب حسب عرض الشاشة
  static double getResponsiveValue({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// الحصول على padding مناسب
  static EdgeInsets getPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 64);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  /// الحصول على عدد الأعمدة للشبكة
  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return 3;
    }
    return 2;
  }

  /// الحصول على نسبة العرض للارتفاع للشبكة
  static double getGridChildAspectRatio(BuildContext context) {
    if (isDesktop(context)) {
      return 0.8;
    } else if (isTablet(context)) {
      return 0.75;
    }
    return 0.7;
  }
}

/// امتدادات للـ BuildContext
extension ResponsiveExtension on BuildContext {
  /// عرض الشاشة
  double get screenWidth => Responsive.width(this);

  /// ارتفاع الشاشة
  double get screenHeight => Responsive.height(this);

  /// حجم الشاشة
  Size get screenSize => Responsive.size(this);

  /// هل الشاشة صغيرة
  bool get isMobile => Responsive.isMobile(this);

  /// هل الشاشة متوسطة
  bool get isTablet => Responsive.isTablet(this);

  /// هل الشاشة كبيرة
  bool get isDesktop => Responsive.isDesktop(this);

  /// padding مناسب
  EdgeInsets get responsivePadding => Responsive.getPadding(this);
}

/// أحجام ثابتة
class AppSizes {
  // المسافات
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // نصف قطر الزوايا
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  // الأحجام
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // ارتفاعات
  static const double buttonHeight = 52;
  static const double inputHeight = 56;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
}
