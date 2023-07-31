import 'package:json_annotation/json_annotation.dart';

part 'token_reponse.g.dart';

@JsonSerializable()
class TokenResponse {
  final String accessToken;
  TokenResponse({
    required this.accessToken,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}
