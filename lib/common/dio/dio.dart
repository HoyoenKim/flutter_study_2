import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_study_2/common/const/data.dart';
import 'package:flutter_study_2/common/secure_storage/secure_storage.dart';
import 'package:flutter_study_2/user/provider/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storage: storage, ref: ref),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 1) 요청을 보낼 때
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] [${options.uri}]');
    // Header에 accessToken이 있으면 토큰을 넣음
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    // Header에 refreshToken이 있으면 토큰을 넣음
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] [${response.requestOptions.uri}]');
    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] [${err.requestOptions.uri}]');

    // 401 Error (status code)
    // accessToken reissuance 시도하고 issue되면 이를 이용하여 req
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      // refreshToken need to be inssue
      // reject => error 그대로 / resolve => error 해결
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      // 401 error and not refresh token request <=> access token expired
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        // change access token in req header
        options.headers.addAll(
          {
            'authorization': 'Bearer $accessToken',
          },
        );

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // req re-request
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        // refresh token expired

        // circular dependency error (A -> B / B -> A => A -> B -> A -> B ...)
        // ref.read(userMeProvider.notifier).logout();

        // dio는 userMeProvider에서 DI 되므로
        // dio에서 userMeProvider를 DI 할 수 없다. (빌드 타임에 알고 있어야 하므로.)
        // 직접 DI를 하지 않는 객체를 만들어서 해결한다. (authProvider)
        ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
