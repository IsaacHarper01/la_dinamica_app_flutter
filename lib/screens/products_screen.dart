import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/screens/edit_products_screen.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/product_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/add_product_info.dart';
import 'package:la_dinamica_app/screens/sales_screen.dart';


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
    final screenHeight =isPortatil? MediaQuery.of(context).size.height: MediaQuery.of(context).size.height * 1.2;
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
                  FilledButton.icon(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => SalesScreen(user: user), 
                        )
                      );
                    },
                    label: const Text(
                      'Ventas del día',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.sell,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(colorList[3]),
                    ),
                  ),
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
          productsBox(user, screenWidth, screenHeight),
        ],
      ),
    )
    , error: (e,_)=> Scaffold(body: Center(child: Text('Error al obtener los productos'),),), 
    loading: ()=> Scaffold(body: Center(child: CircularProgressIndicator(),),)
    );
  }
    
  Widget productsBox(UserLocal user, double screenWidth, double screenHeight){
    final productsAsync = ref.watch(productProvider);
    final date = ref.watch(dateProvider).today;
    
    return productsAsync.when(
      error: (e, st) => Center(child: Text('Error: $e')), 
      loading:() => const Center(child: CircularProgressIndicator()),
      data:(products) {
        return SizedBox(
              height: screenHeight-180, //Change this to sizeHeight of the screen
              width: screenWidth,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: 
                (context,index){
                  return ProductCard(
                    product: products[index], 
                    user: user,
                    date: date,
                    onDelete:(){
                      ref.read(productProvider.notifier)
                        .deleteProduct(products[index]);
                      },
                    );
                    }
                  ), 
                ); 
              }
            );
          }
  }

class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final UserLocal user;
  final VoidCallback onDelete;
  final String date;

  const ProductCard({
    super.key, 
    required this.product,
    required this.user,
    required this.onDelete,
    required this.date,
    });

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  late final DataStoreReadService aws;

  @override
  void initState() {
    super.initState();
    aws = DataStoreReadService();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(imageProvider(widget.product.image!));

    return SizedBox(
      height: 90,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: widget.product.stock!>0 ? colorList[1] : Color.fromRGBO(109, 36, 36, 0.498),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: imageUrl.when(
                    data: (url) => Image.network(
                      url ?? "",
                      fit: BoxFit.cover,
                    ),
                    error: (e, _) => Image.asset(
                      'assets/images/default_product.jpg',
                      fit: BoxFit.cover,
                    ),
                    loading: () => const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Product info (name + price)
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${widget.product.price!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.product.code}",
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),               
              Expanded(
                flex: 1,
                child: Text(
                  "Unidades: ${widget.product.stock}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),

              // Sell button
              if(widget.user.permissions["sellProducts"]==true&&widget.product.stock!>0)...[
                ElevatedButton(
                onPressed: () async{
                  if(widget.product.stock!>0)
                  {
                  await aws.sellProduct(widget.product, widget.user, widget.date);
                  await ref.read(productProvider.notifier).loadProducts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text('Producto descontado del inventario'),
                    backgroundColor: Colors.green,
                      ),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                      content: Text('Este producto no tiene unidades'),
                      backgroundColor: Colors.red,
                      ),);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text("Vender", style: TextStyle(fontSize: 13)),
                ),
              ],

              const SizedBox(width: 4),

              // Popup menu
              if(widget.user.permissions["editProducts"]==true)...[
                PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (value) async {
                  if (value == 'delete') {
                    widget.onDelete();
                  } else if (value == 'update') {
                    await Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                        EditProductInfo(
                          product: widget.product
                          )
                        )
                      );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'update',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                ],
              ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

