import 'package:flutter/material.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/widgets/products_page.dart/product_card_test.dart';

Future<void> showProductInfoDialog(BuildContext context, Product product, UserLocal user) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // User must press a button to close
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProductCardSell(product: product, user: user),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red), 
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    },
  );
}
