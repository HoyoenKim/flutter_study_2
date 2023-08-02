import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/provider/pagination_provider.dart';
import 'package:flutter_study_2/order/model/order_model.dart';
import 'package:flutter_study_2/order/repository/order_repository.dart';
import 'package:flutter_study_2/user/provider/basket_provider.dart';
import 'package:uuid/uuid.dart';

import '../model/post_order_body.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(orderRepositoryProvider);
    return OrderStateNotifier(
      ref: ref,
      repository: repository,
    );
  },
);

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    const uuid = Uuid();
    final id = uuid.v4();
    final state = ref.read(basketProvider);

    try {
      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice:
              state.fold<int>(0, (p, n) => p + n.count * n.product.price),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
