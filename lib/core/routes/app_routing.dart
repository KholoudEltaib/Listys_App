import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/di/service_locator.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';
import 'package:listys_app/core/routes/app_routes.dart';
import 'package:listys_app/features/favorite/presentation/screens/empty_favorite.dart';
import 'package:listys_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:listys_app/features/home/presentation/screens/home_screen.dart';
import 'package:listys_app/features/home/presentation/widgets/buttom_navbar.dart';
import 'package:listys_app/features/splash/splash_screen.dart';
import 'package:listys_app/features/sining/login_screen.dart';

class AppRouting {
  final localeCubit = getIt<LocaleCubit>();
  Route onGenerateRouting(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

    case AppRoutes.mainScreen:
        return pageRouteBuilder(
          BlocProvider(
            create: (_) => HomeCubit(getIt(), localeCubit)..loadHome(),
            child: const MainScreen(),
          ),
        );

      case AppRoutes.homeScreen:
        return pageRouteBuilder(
          BlocProvider(
            create: (_) => HomeCubit(getIt(), localeCubit)..loadHome(),
            child: const HomeScreen(),  
          ),
        );

        case AppRoutes.countryCities:
          return pageRouteBuilder(
            const Scaffold(
              body: Center(child: Text('Favorite Screen')),
            ),
          );

        // case AppRoutes.favoriteScreen:
        //   return MaterialPageRoute(
        //     builder: (_) => BlocProvider(
        //       create: (_) => getIt<FavoritesCubit>()..fetchFavorites(),
        //       child: const FavoritesRoot(),
        //     ),
        //   );


        // case AppRoutes.favoriteRoot:
        // return pageRouteBuilder(
        // BlocProvider(
        //   create: (_) => getIt<FavoritesCubit>()..fetchFavorites(),
        //   child: const FavoritesRoot(),
        // )
        // );

      case AppRoutes.emptyFavorite:
        return MaterialPageRoute(
          builder: (_) => const EmptyFavorite(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No Route Found')),
          ),
        );
    }
  }
}


PageRouteBuilder pageRouteBuilder(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.easeInOutQuart;

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 600), // ⬅ better UX
  );
}
