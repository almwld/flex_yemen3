import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

/// شاشة تسجيل الدخول
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGuest = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SupabaseService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'فشل تسجيل الدخول: $e',
              style: const TextStyle(fontFamily: 'Changa'),
            ),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _loginAsGuest() {
    setState(() => _isGuest = true);
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // الشعار
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      size: 50,
                      color: AppTheme.darkText,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .scale(delay: const Duration(milliseconds: 200)),
                const SizedBox(height: 32),
                // عنوان الترحيب
                Text(
                  'مرحباً بك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextColor(context),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                    .slideY(begin: 0.2),
                const SizedBox(height: 8),
                Text(
                  'سجل دخول للمتابعة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 16,
                    color: AppTheme.getSecondaryTextColor(context),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 400)),
                const SizedBox(height: 40),
                // حقل البريد الإلكتروني
                CustomTextField(
                  label: 'البريد الإلكتروني أو رقم الهاتف',
                  hint: 'example@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 500))
                    .slideX(begin: -0.2),
                const SizedBox(height: 20),
                // حقل كلمة المرور
                PasswordTextField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 600))
                    .slideX(begin: -0.2),
                const SizedBox(height: 12),
                // نسيت كلمة المرور
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: const Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(
                        fontFamily: 'Changa',
                        color: AppTheme.goldColor,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 700)),
                const SizedBox(height: 24),
                // زر تسجيل الدخول
                CustomButton(
                  text: 'تسجيل الدخول',
                  onPressed: _login,
                  isLoading: _isLoading,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 800))
                    .scale(delay: const Duration(milliseconds: 900)),
                const SizedBox(height: 16),
                // زر الدخول كضيف
                CustomButton(
                  text: 'الدخول كضيف',
                  onPressed: _loginAsGuest,
                  isOutlined: true,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 900)),
                const SizedBox(height: 32),
                // خط فاصل
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppTheme.getDividerColor(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'أو',
                        style: TextStyle(
                          fontFamily: 'Changa',
                          color: AppTheme.getSecondaryTextColor(context),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppTheme.getDividerColor(context),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 1000)),
                const SizedBox(height: 24),
                // رابط إنشاء حساب
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(
                        fontFamily: 'Changa',
                        color: AppTheme.getSecondaryTextColor(context),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontFamily: 'Changa',
                          color: AppTheme.goldColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 1100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
