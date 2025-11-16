import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/overall_analytic_states.dart';
import 'package:karwaan_flutter/domain/models/board/overall_analytics.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class OverallAnalyticsCubit extends Cubit<OverallAnalyticStates> {
  final BoardRepo boardRepo;
  OverallAnalytics? _lastAnalytics;

  OverallAnalyticsCubit(this.boardRepo) : super(OverallAnalyticInitial());

  Future<void> getOverallAnalytics() async {
    if (state is OverallAnalyticsLoaded) return;
    emit(OverallAnalyticsLoading());
    try {
      final analytics = await boardRepo.getOverAllAnalytics();

      // Only emit if data actually changed
      if (!_hasAnalyticsChanged(analytics)) {
        return;
      }

      _lastAnalytics = analytics;
      emit(OverallAnalyticsLoaded(analytics));
    } catch (e) {
      emit(OverallAnalyticError(ExceptionMapper.toMessage(e)));
    }
  }

  bool _hasAnalyticsChanged(OverallAnalytics newAnalytics) {
    if (_lastAnalytics == null) return true;

    return _lastAnalytics!.totalCards != newAnalytics.totalCards ||
        _lastAnalytics!.compeletedCards != newAnalytics.compeletedCards ||
        _lastAnalytics!.totalBoard != newAnalytics.totalBoard;
  }
}
