import 'package:dio/dio.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';

class LanguageInterceptor extends Interceptor {
  final LocaleCubit localeCubit;

  LanguageInterceptor(this.localeCubit);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = localeCubit.state.locale.languageCode;
    super.onRequest(options, handler);
  }
}

