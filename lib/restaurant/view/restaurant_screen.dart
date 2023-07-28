import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_2/common/dio/dio.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:flutter_study_2/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_study_2/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';
import '../component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    //Future<List>
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

    final resp =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();

    return resp.data;
  }

  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: FutureBuilder<List<RestaurantModel>>(
              future: paginateRestaurant(),
              builder:
                  (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    //final item = snapshot.data![index];
                    //final pItem = RestaurantModel.fromJson(
                    //  item,
                    //);

                    final pItem = snapshot.data![index];

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
            )),
      ),
    );
  }
}
