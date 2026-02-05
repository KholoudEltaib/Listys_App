
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/di/service_locator.dart';
import 'package:listys_app/core/routes/app_routes.dart';
import 'package:listys_app/core/routes/app_routing.dart';
import 'package:listys_app/core/theme/gradient_background.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_state.dart';
import 'package:listys_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:listys_app/core/utils/storage_helper.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageHelper.init();
  
  await setupServiceLocator();

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<FavoriteCubit>()),
        BlocProvider(create: (_) => getIt<SearchCubit>()), 
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp(
            title: 'Listys',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouting().onGenerateRouting,
            initialRoute: AppRoutes.splashScreen,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: localeState.locale,
            theme: ThemeData.dark(),
            builder: (context, child) {
              if (child == null) {
                return const SizedBox.shrink();
              }

              return Directionality(
                textDirection:
                    localeState.isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: GradientBackground(child: child),
              );
            },
          );
        },
      ),
    );
  }
}



