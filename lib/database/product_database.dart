import 'package:ak_warehouse/database/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'product.dart';

enum SortBy {name, count}
enum SortOrder {asc, desc}

class ProductDatabase extends ChangeNotifier {
  final isarService = IsarService();
  Product? fetchedProduct;
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
    await searchProducts("");
  }

  //search function for catalogue page
  Future<void> searchProducts(String query, {SortBy sortBy = SortBy.name, SortOrder sortOrder = SortOrder.asc}) async {
      final cleanedQuery = query.replaceAll(RegExp(r'[^a-zA-Z0-9]'), "");
      final subsequence = cleanedQuery.split('').map(RegExp.escape).join('.*?');
      if (subsequence.isEmpty) {
        final products = await isarService.isar.products.where().findAll();
        debugPrint('[ISAR] Found ${products.length} total products!');
        searchedProducts.clear();
        searchedProducts.addAll(products);
        sortProductList(sortBy, sortOrder);
        notifyListeners();
        return;
      }
      else {
      final reg = RegExp(subsequence, caseSensitive: false);
      final products = await isarService.isar.products.filter().group((q) => q
          .nameContains(cleanedQuery[0], caseSensitive: false)
          .or()
          .descriptionContains(cleanedQuery[0], caseSensitive: false)
          .or()
          .modelContains(cleanedQuery[0], caseSensitive: false))
      .or()
      .compatibleListElement((c) => c
          .producerContains(cleanedQuery[0], caseSensitive: false)
          .or()
          .modelContains(cleanedQuery[0], caseSensitive: false)
      ).findAll();

      final results = products.where((p) {
        return 
          reg.hasMatch(p.name) ||
          reg.hasMatch(p.model) ||
          reg.hasMatch(p.description) ||
          p.compatibleList.any((c) => reg.hasMatch(c.producer ?? "") || reg.hasMatch(c.model ?? ""));
      }).toList();

      debugPrint('[ISAR] Found ${products.length} products by query search!');
      searchedProducts.clear();
      searchedProducts.addAll(results);
    }
    sortProductList(sortBy, sortOrder);
    notifyListeners();
  }

  //Sort product list with parameters
  void sortProductList(SortBy sortBy, SortOrder order){
    if(sortBy == SortBy.name){
      if(order == SortOrder.asc){
        searchedProducts.sort((a, b) => a.name.compareTo(b.name));
      }else if(order == SortOrder.desc){
        searchedProducts.sort((a, b) => b.name.compareTo(b.name));
      }
    }

    if(sortBy == SortBy.count){
      if(order == SortOrder.asc){
        searchedProducts.sort((a, b) => a.count.compareTo(b.count));
      }else if(order == SortOrder.desc){
        searchedProducts.sort((a, b) => b.count.compareTo(a.count));
      }
    }
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
