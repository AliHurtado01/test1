import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/helpers/product_mapper.dart';
import '../data/services/product_service.dart';
import '../ui/products/products_state.dart';
import '../ui/products/products_viewmodel.dart';
import 'core_providers.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductService(dio: dio, apiBaseUrl: null);
});

final productMapperProvider = Provider<ProductMapper>((ref) {
  return ProductMapper();
});

final productsViewModelProvider =
    NotifierProvider<ProductsViewModel, ProductsState>(() {
      return ProductsViewModel();
    });
