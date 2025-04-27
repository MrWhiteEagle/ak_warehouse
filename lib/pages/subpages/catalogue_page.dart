import 'package:ak_warehouse/database/product.dart';
import 'package:ak_warehouse/database/product_database.dart';
import 'package:ak_warehouse/widgets/catalogue_search_bar.dart';
import 'package:ak_warehouse/widgets/product_animated_container_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({super.key, required this.onSellPageRequested});

  final Function(Product) onSellPageRequested;

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  //Global page vars
  final searchController = TextEditingController();
  String temp = 'Wyszukiwanie';

  List<Product> expandedIndexes = [];
  List<Product> expandedContentControl = [];
  double tileHeight = 80;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductDatabase>(
      context,
      listen: false,
    ).searchProducts(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.5,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/kbwy_logo.jpg', scale: 1.2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Katalog Produktów',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          CatalogueSearchBar(
            searchController: searchController,
            querySearchCallback: (query) async {
              setState(() {
                temp = query;
              });
              await Provider.of<ProductDatabase>(
                context,
                listen: false,
              ).searchProducts(query);
            },
          ),
          SizedBox(height: 10),
          Text(temp),
          Consumer<ProductDatabase>(
            builder: (context, db, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  spacing: 5,
                  children:
                      db.searchedProducts.map((product) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!expandedIndexes.contains(product)) {
                                expandedIndexes.add(product);
                              } else {
                                expandedIndexes.remove(product);
                              }

                              if (expandedIndexes.contains(product)) {
                                Future.delayed(Duration(milliseconds: 130), () {
                                  if (mounted &&
                                      expandedIndexes.contains(product)) {
                                    setState(() {
                                      if (!expandedContentControl.contains(
                                        product,
                                      )) {
                                        expandedContentControl.add(product);
                                      }
                                    });
                                  }
                                });
                              } else {
                                expandedContentControl.remove(product);
                              }
                            });
                          },
                          child: ProductAnimatedContainerTileCatalogue(
                            expandedIndexes: expandedIndexes,
                            tileHeight: tileHeight,
                            expandedContentControl: expandedContentControl,
                            product: product,
                            sellRequest: (product) {
                              debugPrint('GOT PRODUCT CATALOGUE');
                              widget.onSellPageRequested(product);
                            },
                          ),
                        );
                      }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
