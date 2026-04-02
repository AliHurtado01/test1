import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/dio_config.dart';
import '../data/services/location_service.dart';
import '../data/mock/mock_interceptor.dart'; 

final mockInterceptorProvider = Provider<MockInterceptor>((ref) {
  return MockInterceptor();
});

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

  // Si useMock es true (que es el valor por defecto), 
  // Riverpod lee el mockInterceptorProvider y lo inyecta en Dio.
  if (config.useMock) {
    dio.interceptors.add(ref.read(mockInterceptorProvider));
  }

  return dio;
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});