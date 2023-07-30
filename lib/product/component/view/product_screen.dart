import 'package:flutter/material.dart';
import 'package:flutter_study_2/common/component/pagination_list_view.dart';
import 'package:flutter_study_2/product/provider/product_provider.dart';
import 'package:flutter_study_2/restaurant/view/restaurant_detail_screen.dart';

import '../../model/product_model.dart';
import '../product_card.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        RestaurantDetailScreen(id: model.restaurant.id),
                  ),
                );
              },
              child: ProductCard.fromProductModel(model: model));
        });
  }
}
