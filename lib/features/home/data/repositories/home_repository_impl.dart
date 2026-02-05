import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;
  final HomeLocalDataSource local;

  HomeRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<HomeEntity> getHomeData() async {
    try {
      final home = await remote.getHomeData();
      local.cacheHome(home);
      return home;
    } catch (e) {
      final cached = local.getCachedHome();
      if (cached != null) return cached;
      rethrow;
    }
  }
}
