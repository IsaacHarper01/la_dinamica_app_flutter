

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/storageS3.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final productProvider = StateNotifierProvider<ProductNotifier ,AsyncValue<List<Product>>>(
  (ref) => ProductNotifier(ref),
);

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>>{
    final Ref ref;

  ProductNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadProducts();
  }
  final DataStoreReadService _dataStoreReadService = DataStoreReadService();
  final DataStoreService _dataStoreService = DataStoreService();
  final DataStoreDeleteService _dataStoreDeleteService = DataStoreDeleteService();
  final Storages3 _s3service = Storages3();
  
  Future<void> loadProducts()async{
    final user = await ref.watch(userProvider.future);
    try{
      safePrint('Getting products for tenant: ${user.tenant.tenant_id}');
      final allproducts = await _dataStoreReadService.getProducts(user.tenant.tenant_id);
      state = AsyncValue.data(allproducts);
      safePrint('Productos: $allproducts');
    }
    catch(e, st){
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProducts(String name, String? image, String code, String tenaniId, int stock, double price, String category)async{
        if(image!=null)
        {
        _dataStoreService.saveProduct(code: code, name: name, tenaniId: tenaniId, price: price, image: image, stock: stock, category: category);
        }
        loadProducts();
      }
  Future<void> deleteProduct(Product product)async{
      await _s3service.deleteFile(product.image!);
      safePrint('imagen eliminada correctamente');
      await _dataStoreDeleteService.deleteProduct(product);
      loadProducts();
  }
}

