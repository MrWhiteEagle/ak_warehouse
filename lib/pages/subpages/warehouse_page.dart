import 'package:ak_warehouse/database/product_database.dart';
import 'package:ak_warehouse/widgets/product_animated_container_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Warehouse extends StatefulWidget {
  const Warehouse({super.key});

  @override
  State<Warehouse> createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  @override
  void initState() {
    Provider.of<ProductDatabase>(context, listen: false).fetchAllProducts();
    super.initState();
  }

  List<int> expandedIndexes = [];
  List<int> expandedContentControl = [];
  double tileHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Consumer<ProductDatabase>(
        builder: (context, db, child) {
          if (db.fetchedProducts.isNotEmpty) {
            return ListView.builder(
              itemCount: db.fetchedProducts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!expandedIndexes.contains(index)) {
                          expandedIndexes.add(index);
                        } else {
                          expandedIndexes.remove(index);
                        }

                        if (expandedIndexes.contains(index)) {
                          Future.delayed(Duration(milliseconds: 130), () {
                            if (mounted && expandedIndexes.contains(index)) {
                              setState(() {
                                if (!expandedContentControl.contains(index)) {
                                  expandedContentControl.add(index);
                                }
                              });
                            }
                          });
                        } else {
                          expandedContentControl.remove(index);
                        }
                      });
                    },
                    child: ProductAnimatedContainerTile(
                      expandedIndexes: expandedIndexes,
                      tileHeight: tileHeight,
                      expandedContentControl: expandedContentControl,
                      index: index,
                      db: db,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Brak produktów'));
          }
        },
      ),
    );
  }
}
