import 'package:ak_warehouse/database/product_database.dart';
import 'package:ak_warehouse/widgets/catalogue_search_bar.dart';
import 'package:ak_warehouse/widgets/db_sort_output.dart';
import 'package:ak_warehouse/widgets/product_animated_container_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/product.dart';

class Warehouse extends StatefulWidget {
  const Warehouse({super.key});

  @override
  State<Warehouse> createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {

  List<Product> expandedIndexes = [];
  List<Product> expandedContentControl = [];
  double tileHeight = 80;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  SortBy sortBy = SortBy.name;
  SortOrder sortOrder = SortOrder.asc;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductDatabase>(context, listen: false)
          .searchProducts(searchQuery, sortBy: sortBy, sortOrder: sortOrder);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        spacing: 10,
        children: [
          CatalogueSearchBar(searchController: searchController, querySearchCallback: (query) async {
            setState(() {
              searchQuery = query;
            });
            await Provider.of<ProductDatabase>(context, listen: false).searchProducts(query);
          }),
          DbSortOutput(context: context, sortCallback: (SortBy sortBy, SortOrder order) async {
            setState(() {
              this.sortBy = sortBy;
              sortOrder = order;
            });
            await Provider.of<ProductDatabase>(context, listen: false).searchProducts(searchQuery, sortOrder: order, sortBy: sortBy);
          }),
          Expanded(
            child:
      Consumer<ProductDatabase>(
        builder: (context, db, child) {
          var products = db.searchedProducts;
          if (products.isEmpty) {
            return Center(child: Text('Brak produktów'));
          }else {
            return SingleChildScrollView(
                child:
                Column(
                  children: products.map((product) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!expandedIndexes.contains(product)) {
                          expandedIndexes.add(product);
                        } else {
                          expandedIndexes.remove(product);
                        }

                        if (expandedIndexes.contains(product)) {
                          Future.delayed(Duration(milliseconds: 130), () {
                            if (mounted && expandedIndexes.contains(product)) {
                              setState(() {
                                if (!expandedContentControl.contains(product)) {
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
                    child: ProductAnimatedContainerTile(
                      expandedIndexes: expandedIndexes,
                      tileHeight: tileHeight,
                      expandedContentControl: expandedContentControl,
                      product: product,
                      db: db,
                    ),
                  ),
                );
                  }).toList(),
                )
            );
          }
        },
      ),
          )
        ],
      )
    );
  }
}
