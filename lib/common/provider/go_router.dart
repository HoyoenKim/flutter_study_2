import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/user/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  //watch를 사용하면 authProvider 가 업데이트 될때마다 다시 빌드된다. (라우터는 다시 빌드 x, 싱글톤)
  final provider = ref.read(authProvider);
  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
