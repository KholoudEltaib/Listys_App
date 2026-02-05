// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get welcomeBack => 'مرحبًا بعودتك!';

  @override
  String get home => 'الرئيسية';

  @override
  String get nearYou => 'بالقرب منك';

  @override
  String get featured => 'مميز 💫';

  @override
  String get noCountriesFound => 'لم يتم العثور على دول';

  @override
  String get noPlacesNearYou => 'لا توجد أماكن بالقرب منك.';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get explore => 'استكشاف';

  @override
  String get favorites => 'المفضلة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get name => 'الاسم';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get yourFavoritePlacesWillAppearHere => 'ستظهر أماكنك المفضلة هنا.';

  @override
  String get welcomeToHomeScreen => 'مرحبًا بك في الصفحة الرئيسية!';

  @override
  String detectedCountry(Object country) {
    return 'تم اكتشاف الدولة: $country';
  }

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح!';

  @override
  String get allPasswordFieldsRequired => 'جميع حقول كلمة المرور مطلوبة.';

  @override
  String get newPasswordConfirmationNoMatch =>
      'كلمة المرور الجديدة وتأكيدها غير متطابقين.';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور بنجاح!';

  @override
  String failedToLoadCountries(Object statusCode) {
    return 'فشل تحميل الدول: $statusCode';
  }

  @override
  String errorFetchingCountries(Object error) {
    return 'حدث خطأ أثناء جلب الدول: $error';
  }

  @override
  String get noAddressProvided => 'لا يوجد عنوان متوفر';

  @override
  String get searchForCountry => 'ابحث عن مدينة...';

  @override
  String get areYouSureLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get deleteAccountConfirm =>
      'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get delete => 'حذف';

  @override
  String unsupportedCountry(Object country) {
    return 'عذراً، بلدك ($country) غير مدعوم حالياً. نحن نعمل على التوسع قريباً!';
  }

  @override
  String get language => 'اللغة';

  @override
  String get profileInfo => 'معلومات الملف الشخصي';

  @override
  String get orSignInWith => 'أو تسجيل الدخول بإستخدام';
}
