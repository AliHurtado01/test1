import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/domain/product.dart';
import '../../providers/product_providers.dart';
import 'products_state.dart';
import '../../utils/snackbar_util.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
              Text(
                state.isLoading || state.products.isEmpty
                    ? l10n.products
                    : '${l10n.products} (${state.products.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContent(state, l10n),
        ],
      ),
    );
  }

  Widget _buildContent(ProductsState state, AppLocalizations l10n) {
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
            '${l10n.errorPrefix} ${state.error}',
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                l10n.noProductsFound,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
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
        separatorBuilder: (_, _) => const Divider(),
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
    final l10n = AppLocalizations.of(context)!;
    final bool isOutOfStock = product.stock <= 0;
    final stockColor = isOutOfStock ? Colors.red[700] : Colors.green[700];
    final stockBackgroundColor = isOutOfStock
        ? Colors.red[50]
        : Colors.green[50];
    final stockText = isOutOfStock ? l10n.outOfStock : '${l10n.stockPrefix} ${product.stock}';

    return ListTile(
      contentPadding: EdgeInsets.zero,

      onTap: () async {
        await Clipboard.setData(ClipboardData(text: product.id));
        if (context.mounted) {
          SnackBarUtil.show(
            context,
            message: 'ID ${product.id} ${l10n.idCopied}',
            type: SnackBarType.success,
            duration: const Duration(seconds: 2),
          );
        }
      },

      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.inventory_2_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),

      title: Text(
        product.nombre,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),

      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${l10n.businessPrefix} ${product.businessId}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),

      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: stockBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          stockText,
          style: TextStyle(
            color: stockColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}