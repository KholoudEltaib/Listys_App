import '../models/home_model.dart';

abstract class HomeLocalDataSource {
  HomeModel? getCachedHome();
  void cacheHome(HomeModel home);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeModel? _cachedHome;

  @override
  HomeModel? getCachedHome() {
    return _cachedHome;
  }

  @override
  void cacheHome(HomeModel home) {
    _cachedHome = home;
  }
}
