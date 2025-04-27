import 'package:ak_warehouse/database/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'product.dart';

class ProductDatabase extends ChangeNotifier {
  final isarService = IsarService();
  Product? fetchedProduct;
  final List<Product> fetchedProducts = [];
  final List<Product> searchedProducts = [];
  final List<Product> sellSearch = [];

  //CRUD
  Future<void> createProduct(Product newProduct) async {
    await isarService.isar
        .writeTxn(() async {
          isarService.isar.products.put(newProduct);
        })
        .then((_) {
          debugPrint('[ISAR] Created product ${newProduct.name}!');
        })
        .catchError((error) {
          debugPrint(
            '[ISAR] Error creating product ${newProduct.name}!: $error',
          );
        });
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct) async {
    await isarService.isar
        .writeTxn(() async {
          await isarService.isar.products.put(newProduct);
        })
        .then((_) {
          debugPrint('[ISAR] Updated product ${newProduct.name}!');
        })
        .catchError((error) {
          debugPrint(
            '[ISAR] Error updating product ${newProduct.name}!: $error',
          );
        });
    notifyListeners();
  }

  //fetch product by id//UNUSED FOR NOW
  Future<void> fetchProduct(Id id) async {
    final product = await isarService.isar.products.get(id);
    if (product != null) {
      debugPrint('[ISAR] Found product: ${product.name}');
      fetchedProduct = product;
      notifyListeners();
    } else {
      debugPrint('[ISAR] Product returned null!');
    }
  }

  //fetch all products
  Future<void> fetchAllProducts() async {
    final products = await isarService.isar.products.where().findAll();
    debugPrint('[ISAR] Fetched ${products.length} total products!');
    fetchedProducts.clear();
    fetchedProducts.addAll(products);
    fetchedProducts.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  //search function for catalogue page
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      final products = await isarService.isar.products.where().findAll();
      debugPrint('[ISAR] Found ${products.length} total products!');
      searchedProducts.clear();
      searchedProducts.addAll(products);
      notifyListeners();
    } else {
      final products =
          await isarService.isar.products
              .filter()
              .group(
                (q) => q
                    .nameContains(query, caseSensitive: false)
                    .or()
                    .descriptionContains(query, caseSensitive: false)
                    .or()
                    .modelContains(query, caseSensitive: false)
                    .or()
                    .compatibleListElement(
                      (comp) => comp
                          .modelContains(query, caseSensitive: false)
                          .or()
                          .producerContains(query, caseSensitive: false),
                    ),
              )
              .findAll();
      debugPrint('[ISAR] Found ${products.length} products by query search!');
      products.sort((a, b) => a.count.compareTo(b.count));
      searchedProducts.clear();
      searchedProducts.addAll(products);
    }
    notifyListeners();
  }

  //search function for sellpage
  Future<void> searchSellProducts() async {
    final products =
        await isarService.isar.products
            .filter()
            .group((q) => q.countGreaterThan(0))
            .findAll();
    debugPrint(
      '[ISAR] Found ${products.length} products with wh state greater than 0!',
    );
    sellSearch.clear();
    sellSearch.addAll(products);

    notifyListeners();
  }

  Future<void> deleteProduct(Id id) async {
    await isarService.isar
        .writeTxn(() async {
          await isarService.isar.products.delete(id);
        })
        .then((_) {
          debugPrint('[ISAR] Deleted Product $id!');
        })
        .catchError((error) {
          debugPrint('[ISAR] Error deleting product $id!: $error');
        });
    notifyListeners();
  }

  Future<void> resetProductDatabase() async {
    await isarService.isar.writeTxn(() async {
      await isarService.isar.products.clear();
    });
    debugPrint('[ISAR] CLEAR DATABASE');
  }
}
