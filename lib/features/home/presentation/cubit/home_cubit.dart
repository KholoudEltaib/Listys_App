import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;
  final LocaleCubit localeCubit;

  late final StreamSubscription _localeSubscription;

  HomeCubit(this.getHomeDataUseCase, this.localeCubit) : super(HomeInitial()) {
  _localeSubscription = localeCubit.stream.listen((_) {
    loadHome(); 
  });
}


  Future<void> loadHome() async {
    emit(HomeLoading());
    try {
      final home = await getHomeDataUseCase();
      emit(HomeLoaded(home));
    } catch (e) {

      print("error $e");
      emit(HomeError('Failed to load home loadHome'));
    }
  }

  @override
  Future<void> close() {
    _localeSubscription.cancel();
    return super.close();
  }
}
