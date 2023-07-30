import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/restaurant/repository/restaurant_repository.dart';
import 'package:collection/collection.dart';
import '../../common/provider/pagination_provider.dart';
import '../model/restaurant_model.dart';

final restaurantDetialProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  final pState = state; //autocast
  return pState.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 아직 데이터가 하나도 없는 상태 (CursorPagination이 아님)
    // 데이터를 가져온다
    if (state is! CursorPagination) {
      await paginate();
    }

    // Pagniatinon을 했는데도 데이터가 없는 상태 (CursorPagination이 아님)
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id: id);

    // 데이터가 없을 때는 캐시의 끝에 데이터를 추가한다. (데이터의 추가가 상관이 없을 때, 중복 등)

    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ],
      );
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? resp : e)
            .toList(),
      );
    }
  }
}
