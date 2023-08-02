import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/component/pagination_list_view.dart';
import 'package:flutter_study_2/order/component/order_card.dart';
import 'package:flutter_study_2/order/model/order_model.dart';
import 'package:flutter_study_2/order/provider/order_provider.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(context, idnex, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
