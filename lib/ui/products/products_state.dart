import '../../models/domain/product.dart';

class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final String? selectedMarkerId;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.selectedMarkerId,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    String? selectedMarkerId,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedMarkerId: selectedMarkerId ?? this.selectedMarkerId,
    );
  }
}
