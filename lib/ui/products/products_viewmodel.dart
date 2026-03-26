import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/helpers/product_mapper.dart';
import '../../data/services/product_service.dart';
import '../../providers/product_providers.dart';
import 'products_state.dart';

class ProductsViewModel extends Notifier<ProductsState> {
  late final ProductService _service;
  late final ProductMapper _mapper;

  @override
  ProductsState build() {
    _service = ref.read(productServiceProvider);
    _mapper = ref.read(productMapperProvider);

    return const ProductsState();
  }

  Future<void> loadProductsByMarkerId(String markerId) async {
    if (state.selectedMarkerId == markerId && state.products.isNotEmpty) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedMarkerId: markerId,
    );

    try {
      final dtos = await _service.fetchProductsByMarkerId(markerId);
      final products = _mapper.fromDtoToDomain(dtos);

      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        products: [],
      );
    }
  }

  void clearProducts() {
    state = const ProductsState();
  }
}
