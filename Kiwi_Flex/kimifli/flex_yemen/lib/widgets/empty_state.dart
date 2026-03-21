import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_button.dart';

/// ويدج الحالة الفارغة
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.goldColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 50,
                color: AppTheme.goldColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Changa',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextColor(context),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 14,
                  color: AppTheme.getSecondaryTextColor(context),
                ),
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// حالة لا توجد بيانات
class NoDataState extends StatelessWidget {
  final String? message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const NoDataState({
    super.key,
    this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: message ?? 'لا توجد بيانات',
      subtitle: 'لم يتم العثور على أي عناصر حالياً',
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }
}

/// حالة لا توجد نتائج بحث
class NoSearchResultsState extends StatelessWidget {
  final String query;
  final VoidCallback? onClearSearch;

  const NoSearchResultsState({
    super.key,
    required this.query,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'لا توجد نتائج',
      subtitle: 'لم يتم العثور على نتائج لـ "$query"',
      buttonText: 'مسح البحث',
      onButtonPressed: onClearSearch,
    );
  }
}

/// حالة لا توجد إعلانات
class NoAdsState extends StatelessWidget {
  final VoidCallback? onAddAd;

  const NoAdsState({
    super.key,
    this.onAddAd,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.post_add,
      title: 'لا توجد إعلانات',
      subtitle: 'لم تقم بإضافة أي إعلانات بعد',
      buttonText: 'إضافة إعلان',
      onButtonPressed: onAddAd,
    );
  }
}

/// حالة لا توجد مفضلة
class NoFavoritesState extends StatelessWidget {
  final VoidCallback? onBrowse;

  const NoFavoritesState({
    super.key,
    this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'لا توجد مفضلات',
      subtitle: 'لم تقم بإضافة أي منتجات للمفضلة بعد',
      buttonText: 'تصفح المنتجات',
      onButtonPressed: onBrowse,
    );
  }
}

/// حالة لا توجد طلبات
class NoOrdersState extends StatelessWidget {
  final VoidCallback? onShopNow;

  const NoOrdersState({
    super.key,
    this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'لا توجد طلبات',
      subtitle: 'لم تقم بإجراء أي طلبات بعد',
      buttonText: 'تسوق الآن',
      onButtonPressed: onShopNow,
    );
  }
}

/// حالة لا توجد رسائل
class NoMessagesState extends StatelessWidget {
  final VoidCallback? onStartChat;

  const NoMessagesState({
    super.key,
    this.onStartChat,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'لا توجد رسائل',
      subtitle: 'لم تتلق أي رسائل بعد',
      buttonText: 'بدء محادثة',
      onButtonPressed: onStartChat,
    );
  }
}

/// حالة خطأ
class ErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'حدث خطأ',
      subtitle: message ?? 'حدث خطأ أثناء تحميل البيانات',
      buttonText: 'إعادة المحاولة',
      onButtonPressed: onRetry,
    );
  }
}

/// حالة لا يوجد اتصال
class NoInternetState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: 'لا يوجد اتصال',
      subtitle: 'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
      buttonText: 'إعادة المحاولة',
      onButtonPressed: onRetry,
    );
  }
}
