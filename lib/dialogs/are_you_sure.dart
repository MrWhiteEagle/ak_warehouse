import 'package:ak_warehouse/database/product_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void areYouSureDialog(context, productId) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(
            'Czy na pewno?',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Anuluj', style: TextStyle(fontSize: 18)),
            ),
            MaterialButton(
              onPressed: () async {
                await Provider.of<ProductDatabase>(
                  context,
                  listen: false,
                ).deleteProduct(productId);
                await Provider.of<ProductDatabase>(
                  context,
                  listen: false,
                ).fetchAllProducts();
                Navigator.pop(context);
              },
              child: Text(
                'Usuń',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
  );
}
