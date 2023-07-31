import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/view/splash_screen.dart';
import 'package:flutter_study_2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_study_2/user/model/user_model.dart';
import 'package:flutter_study_2/user/provider/useR_me_provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/view/root_tab.dart';
import '../view/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;
  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (_, state) => RestaurantDetailScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen
  // 앱을 처음 시작햇을때 토큰이 존재하는지 확인하고 로그인 스크린, 홈 스크린 중 어디로 보내줄지 확인하는 과정이 필요.
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final logginIn = state.location == '/login';

    // 유저 정보가 없음
    // 로그인 중이면 그대로 로그인 페이지
    // 아니라면 로그인 페이지로 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }

    // 유저 정보가 있음
    // 로그인 중이거나 현재 위치가 SplashScreen이면 홈으로 이동
    if (user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // 유저 정보 에러
    if (user is UserModelError) {
      // 로그아웃
      return logginIn ? null : '/login';
    }

    return null;
  }
}
