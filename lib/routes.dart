import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kru/pages/about_us_page.dart';
import 'package:kru/pages/home_page.dart';
import 'package:kru/pages/pay_page.dart';
import 'package:kru/pages/predict_page.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: '/aboutUs',
    builder: (BuildContext context, GoRouterState state) {
      return const AboutUsPage();
    },
  ),
  GoRoute(
    path: '/predict',
    builder: (BuildContext context, GoRouterState state) {
      return const PredictPage();
    },
  ),
  GoRoute(
    path: '/pay',
    builder: (BuildContext context, GoRouterState state) {
      return const PayPage();
    },
  ),
]);
