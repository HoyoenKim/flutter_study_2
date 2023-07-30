import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/model/model_with_id.dart';

import '../model/pagination_params.dart';
import '../repository/base_pagination_repository.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  PaginationProvider({
    required this.repository,
  }) : super(CursorPagniationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true: 데이터 더 가져오기, false: 새로고침 (현재 상태 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true: cursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    //final resp = await repository.paginate();
    //state = resp;
    // 5가지 가능성: State의 상태
    // 1) CursorPagination: 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading: 데이터가 로딩중인 상태 (현재 캐시 없음)
    // 3) CursorPagniationError: 에러가 있는 상태
    // 4) CursorPagniationRefetching: 첫번째 페이지부터 다시 데이터를 가져올 때
    // 5) CursorPagniationFetchMore: 추가 데이털르 pagniate 요청을 받았을 떄

    try {
      // 바로 반환
      // 1) 다음 데이터가 없는 경우 (hasMore = false)
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }
      // 2) 로딩중 (fetchMore = true and 첫 로딩, 새로고침, 데이터 추가요청)
      final isLoading = state is CursorPagniationLoading; // 현재 데이터 x, 첫 로딩
      final isRefetching =
          state is CursorPaginationRefetching; // 현재 데이터 o, 새로고침
      final isFetchingMore =
          state is CursorPaginationFetchingMore; // 현재 데이터 0, 데이터 추가 요청
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // 데이터 요청
      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // 3) 데이터를 추가로 가져오는 상황 (fetchMore = true)
      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        state = CursorPaginationFetchingMore<T>(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 4) 데이터를 새로 고침하는 상황 (fetchMore = false)
      else {
        if (state is CursorPagination && !forceRefetch) {
          // 4) 데이터를 새로 고침하는 상황 (기존 데이터 존재, 처음부터 다시 받아옴(params after=null), 기존 데이터는 계속 보여줌)
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
              meta: pState.meta, data: pState.data);
        } else {
          // 로딩 화면 (데이터가 없거나 forceRefetch = true)
          state = CursorPagniationLoading();
        }
      }

      // 5) 데이터를 처음 가져오는 상황 (fetchMore = false), 그냥 기본값으로 요청(params after=null)
      // 새로운 데이터
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        // 기존 데이터
        final pState = state as CursorPaginationFetchingMore<T>;

        // 3) 데이터를 추가로 가져오는 상황
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        // 4) 데이터를 새로 고침하는 상황
        // 5) 데이터를 처음 가져오는 상황
        state = resp;
      }
    } catch (e, stack) {
      // 6) 에러
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
