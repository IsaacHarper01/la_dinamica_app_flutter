import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

class ProductCardSell extends ConsumerStatefulWidget {
  final Product product;
  final UserLocal user;

  const ProductCardSell({super.key, required this.product, required this.user});

  @override
  ConsumerState<ProductCardSell> createState() => _ProductCardSellState();
}

class _ProductCardSellState extends ConsumerState<ProductCardSell> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final user = widget.user;
    final imageUrl = ref.watch(imageProvider(product.image!));
    final aws = DataStoreReadService();
    final date = ref.watch(dateProvider).today;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: imageUrl.when(
                  error:
                      (e, _) =>
                          Image.asset('assets/images/default_product.jpg'),
                  loading: () => CircularProgressIndicator(),
                  data:
                      (data) => FadeInImage.assetNetwork(
                        placeholder: 'assets/images/default_product.jpg',
                        image: data ?? "",
                        fit: BoxFit.cover,
                        imageErrorBuilder:
                            (ctx, error, stack) => Container(
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 48,
                                color: Colors.grey.shade600,
                              ),
                            ),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Text(
                  product.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Text(
                  '\$${product.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: Row(
                  children: [
                    _QuantityStepper(
                      quantity: quantity,
                      stock: product.stock ?? 0,
                      onDecrement: () => setState(() => quantity--),
                      onIncrement: () => setState(() => quantity++),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if ((product.stock ?? 0) < 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Este producto no tiene unidades',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            await aws.sellProduct(
                              product,
                              user,
                              date,
                              quantity: quantity,
                            );
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          } on StateError catch (error) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 20,
                        ),
                        label: const Text('Vender'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final int stock;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.stock,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: quantity > 1 ? onDecrement : null,
          icon: const Icon(Icons.remove),
          tooltip: 'Reducir cantidad',
          visualDensity: VisualDensity.compact,
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: quantity < stock ? onIncrement : null,
          icon: const Icon(Icons.add),
          tooltip: 'Aumentar cantidad',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
