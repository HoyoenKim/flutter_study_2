import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/layout/default_layout.dart';
import 'package:flutter_study_2/product/component/product_card.dart';
import 'package:flutter_study_2/restaurant/component/restaurant_card.dart';

import '../model/restaurant_detail_model.dart';
import '../repository/restaurant_repository.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
    //ver1
    ////Future<Map<String, dynamic>>
    //final dio = Dio();
    //dio.interceptors.add(
    //  CustomInterceptor(storage: storage),
    //);
    //final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    //final resp = await dio.get(
    //  'http://$ip/restaurant/$id',
    //  options: Options(
    //    headers: {
    //      'authorization': 'Bearer $accessToken',
    //    },
    //  ),
    //);
    //return resp.data;
    //ver2
    //final dio = ref.watch(dioProvider);
    //final repository =
    //    RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
    //return repository.getRestaurantDetail(id: id);
    return ref
        .watch(
          restaurantRerefpositoryProvider,
        )
        .getRestaurantDetail(
          id: id,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: ref
            .watch(
              restaurantRerefpositoryProvider,
            )
            .getRestaurantDetail(
              id: id,
            ),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //final item = RestaurantDetailModel.fromJson(snapshot.data!);
          return CustomScrollView(
            slivers: [
              renderTop(restaurantDetailModel: snapshot.data!),
              renderLabel(),
              renderProducts(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop(
      {required RestaurantDetailModel restaurantDetailModel}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: restaurantDetailModel,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
