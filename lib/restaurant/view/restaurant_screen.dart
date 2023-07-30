import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/utils/pagination_utils.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:flutter_study_2/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_study_2/restaurant/view/restaurant_detail_screen.dart';

import '../component/restaurant_card.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantProvider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 2) CursorPaginationLoading: 데이터가 로딩중인 상태 (현재 캐시 없음)
    if (data is CursorPagniationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 3) CursorPagniationError: 에러가 있는 상태
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // 1) CursorPagination: 정상적으로 데이터가 있는 상태
    // 4) CursorPagniationRefetching: 첫번째 페이지부터 다시 데이터를 가져올 때
    // 5) CursorPagniationFetchMore: 추가 데이털르 pagniate 요청을 받았을 떄
    final cp = data as CursorPagination<RestaurantModel>;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 데이터입니다ㅠㅠ'),
              ),
            );
          }

          final pItem = cp.data[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                    id: pItem.id,
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              model: pItem,
            ),
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
