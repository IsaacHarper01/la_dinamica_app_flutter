import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/Product.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/add_product_info.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _nameState();
}

class _nameState extends ConsumerState<ProductsScreen> {
  String? productInfo;
  UserLocal? user;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8;
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
    data: (user) =>
    Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40,),
          Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.01),
              child: Row(
                children: [
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => AddProductInfo(), 
                        )
                      );
                    },
                    label: const Text(
                      'Agregar Producto',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(colorList[3]),
                    ),
                  ),
                ],
              ),
            ),
          products(user, screenWidth),
        ],
      ),
    )
    , error: (e,_)=> Scaffold(body: Center(child: Text('Error al obtener los productos'),),), 
    loading: ()=> Scaffold(body: Center(child: CircularProgressIndicator(),),)
    );
  }

  FutureBuilder products(UserLocal user, double screenWidth){
    final aws = DataStoreReadService();
    return FutureBuilder(
        future: aws.getProducts(user.tenant.tenant_id),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
           return Center(child: Text("Error al obtner los productos"));
          }
          else{
            final List<Product> products = snapshot.data;
            if(products.isNotEmpty){
              return SizedBox(
              height: 800,
              width: screenWidth,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: 
                (context,index){
                  return ProductCard(product: products[index]);
                 }
                ), 
              ); 
            }else{
              return Center(heightFactor: 40,child: Text("Aun no tienes productos"));
              }
            }
        },
      );
  } 
}

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({
    super.key, 
    required this.product
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(imageProvider(product.image!));
    
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image with fixed size
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.when(
                    data: (url) => Image.network(
                      url ?? "",
                      fit: BoxFit.cover,
                    ),
                    error: (e, _) => Image.asset(
                      'assets/images/default_profile.jpg',
                      fit: BoxFit.cover,
                    ),
                    loading: () => const Center(
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Text constrained properly
              Column(
                children: [
                SizedBox(height: 8,),
                Text(
                  product.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle( fontWeight: FontWeight.w500),
                ),
                Text(" ${product.price!.toStringAsFixed(2)}"),
                ]
              ),
              ElevatedButton(onPressed: (){

              }, 
              child: Text('Vender')),
              SizedBox(width: 10,),
              Text("${product.stock}"),
            ],
          ),
        ),
      ),
    );


  }
}

