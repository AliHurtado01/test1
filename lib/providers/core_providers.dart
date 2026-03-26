import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/dio_config.dart';
import '../data/services/location_service.dart';

final dioConfigProvider = Provider<DioConfig>((ref) {
  return DioConfig.defaultConfig;
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(dioConfigProvider);
  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: config.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: config.receiveTimeoutSeconds),
      headers: config.headers,
    ),
  );

  return dio;
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});
