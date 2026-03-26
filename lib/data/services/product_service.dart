import 'package:dio/dio.dart';
import '../../models/dto/product_dto.dart';

class ProductService {
  final Dio _dio;
  final String? apiBaseUrl;

  ProductService({required Dio dio, this.apiBaseUrl}) : _dio = dio;

  Future<List<ProductDto>> fetchProductsByMarkerId(String markerId) async {
    return _fetchProducts(markerId);
  }

  Future<List<ProductDto>> _fetchProducts(String markerId) async {
    try {
      final response = await _dio.get('$apiBaseUrl/$markerId/productos');
      final data = response.data as List;
      return data.map((json) => ProductDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    }
  }
}
