import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:flutter_study_2/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_study_2/restaurant/view/restaurant_detail_screen.dart';

import '../component/restaurant_card.dart';

class RestaurantScreen extends ConsumerWidget {
  Future<CursorPagination<RestaurantModel>> paginateRestaurant(
      WidgetRef ref) async {
    // ver1
    ////Future<List>
    //final dio = Dio();
    //dio.interceptors.add(
    //  CustomInterceptor(storage: storage),
    //);
    //final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    //final resp = await dio.get(
    //  'http://$ip/restaurant',
    //  options: Options(
    //    headers: {
    //      'authorization': 'Bearer $accessToken',
    //    },
    //  ),
    //);
    //return resp.data['data'];
    // ver2
    ////Future<List<RestaurantModel>>
    //final dio = ref.watch(dioProvider);
    //final resp =
    //    await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
    //        .paginate();
    //return resp.data;

    return ref.watch(restaurantRerefpositoryProvider).paginate();
  }

  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: FutureBuilder<CursorPagination<RestaurantModel>>(
            future: ref.watch(restaurantRerefpositoryProvider).paginate(),
            builder: (context,
                AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (_, index) {
                  //final item = snapshot.data![index];
                  //final pItem = RestaurantModel.fromJson(
                  //  item,
                  //);

                  final pItem = snapshot.data!.data[index];

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
              );
            },
          ),
        ),
      ),
    );
  }
}
