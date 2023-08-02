import 'package:flutter_study_2/common/model/model_with_id.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../common/utils/data_utils.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderProdutModel {
  final String id;
  final String name;
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final int price;

  OrderProdutModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  factory OrderProdutModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProdutModelFromJson(json);
}

@JsonSerializable()
class OrderProductAndCountModel {
  final OrderProdutModel product;
  final int count;

  OrderProductAndCountModel({
    required this.product,
    required this.count,
  });

  factory OrderProductAndCountModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductAndCountModelFromJson(json);
}

@JsonSerializable()
class OrderModel implements IModelWithId {
  @override
  final String id;
  final List<OrderProductAndCountModel> products;
  final int totalPrice;
  final RestaurantModel restaurant;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.restaurant,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
