import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/product/model/product_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter_study_2/user/model/patch_basket_body.dart';
import 'package:flutter_study_2/user/repository/user_me_repository.dart';

import '../model/basket_item_model.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);
    return BasketProvider(repository: repository);
  },
);

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  BasketProvider({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 요청을 먼저 보내고, 응답이 오면 캐시를 업데이트 했었음.
    //await Future.delayed(const Duration(milliseconds: 500));

    // 1) 장바구니에 상품이 없다면, 장바구니에 상품을 추가한다.
    // 2) 장바구니에 상품이 있다면, count++을 한다.
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }

    // 요청을 먼저 보내고, 응답이 오면 캐시를 업데이트 했었음.
    // 이는 앱이 느리게 보이게됨.
    // Optimisitic Response (긍정적 응답)
    // 응답이 성공할 것이라 가정하고 상태를 먼저 업데이트
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // true 면 countd와 관계없이 삭제
    bool isDelete = false,
  }) async {
    // 1) 장바구니에 상품이 없다면, 함수 종료.
    // 2) 장바구니에 상품이 있다면, count--을 한다.
    // 2-1) count = 0 이면 삭제한다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);
    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map((e) => e.product.id == product.id
              ? e.copyWith(
                  count: e.count - 1,
                )
              : e)
          .toList();
    }
    await patchBasket();
  }
}
