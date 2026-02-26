import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';


class ProductCardSell extends ConsumerWidget {
  final Product product;
  final UserLocal user;

  const ProductCardSell({
    super.key, 
    required this.product,
    required this.user,
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(imageProvider(product.image!));
    final aws = DataStoreReadService();
    final date = ref.watch(dateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
          child: InkWell(
          onTap: (){},
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                  aspectRatio: 4 / 3,
                  child: imageUrl.when( 
                    error: (e,_)=>Image.asset('assets/images/default_product.jpg'), 
                    loading: ()=>CircularProgressIndicator(),
                    data: (data) => FadeInImage.assetNetwork(
                    placeholder: 'assets/images/default_product.jpg',
                    image: data ?? "",
                    fit: BoxFit.cover,
                    imageErrorBuilder: (ctx, error, stack) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: Icon(Icons.image_not_supported_outlined, size: 48, color: Colors.grey.shade600),
                    ),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Text(
                product.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                child: ElevatedButton.icon(
                  onPressed: (){
                    aws.sellProduct(product, user, date);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_shopping_cart_outlined, size: 20),
                  label: const Text('Vender'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  
                    ),
                  ),
              ),
           ],
          ),
        ),
      ),
    );
  }
}
