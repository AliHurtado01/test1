import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/domain/product.dart';
import '../../providers/product_providers.dart';
import 'products_state.dart';

class ProductsBottomSheet extends ConsumerStatefulWidget {
  final String markerId;

  const ProductsBottomSheet({super.key, required this.markerId});

  @override
  ConsumerState<ProductsBottomSheet> createState() =>
      _ProductsBottomSheetState();
}

class _ProductsBottomSheetState extends ConsumerState<ProductsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productsViewModelProvider.notifier)
          .loadProductsByMarkerId(widget.markerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsViewModelProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContent(state),
        ],
      ),
    );
  }

  Widget _buildContent(ProductsState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Error: ${state.error}',
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
      );
    }

    if (state.products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('There are no products for this marker.'),
        ),
      );
    }

    return _ProductsList(products: state.products);
  }
}

class _ProductsList extends StatelessWidget {
  final List<Product> products;

  const _ProductsList({required this.products});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductItem(product: product);
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.inventory_2_outlined, color: Colors.blue[700]),
      ),
      title: Text(
        product.nombre,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'ID: ${product.id}',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }
}
