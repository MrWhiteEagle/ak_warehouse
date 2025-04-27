import 'package:ak_warehouse/database/product.dart';
import 'package:ak_warehouse/database/product_database.dart';
import 'package:ak_warehouse/dialogs/add_item_to_sell.dart';
import 'package:ak_warehouse/dialogs/loading_dialog.dart';
import 'package:ak_warehouse/widgets/sell_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellPage extends StatefulWidget {
  final Product? initialP;
  const SellPage({super.key, this.initialP});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  //List containing all fetched items
  List<Product> sellItemsList = [];
  //Map containing all selected items for sell and count of them
  Map<Product, int> finalSellMap = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialP != null) {
      finalSellMap[widget.initialP!] = 1;
      debugPrint('GOT PRODUCT - SELLPAGE');
    }
    Provider.of<ProductDatabase>(context, listen: false).fetchAllProducts();
    sellItemsList.addAll(
      Provider.of<ProductDatabase>(context, listen: false).fetchedProducts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      //MAIN COLUMN ------------------------------------------------------------
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Sprzedaż',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final Product? item = await addItemDialog(
                        context,
                        Provider.of<ProductDatabase>(
                          context,
                          listen: false,
                        ).fetchedProducts,
                      );
                      if (item != null) {
                        setState(() {
                          finalSellMap[item] = 1;
                        });
                      }
                    },
                    child: Text(
                      'Dodaj +',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Produkty',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          Flexible(
            //Flex container for sell items column
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              //PRODUCTS COLUMN-----------------------------------------------------------
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                //SELL ITEMS LIST
                children:
                    finalSellMap.isNotEmpty
                        ? finalSellMap.entries.map((item) {
                          return SellItem(
                            item: item.key,
                            amountSelected: (newAmount) {
                              setState(() {
                                finalSellMap[item.key] = newAmount;
                              });
                            },
                          );
                        }).toList()
                        : [
                          Center(child: Text('Brak produktów')),
                          Center(child: Text('Czas jakieś dodać :)')),
                        ],
              ),
            ),
          ),
          //SAVE BUTTON ------------------------------------------------
          Card(
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () async {
                  final List<Future<void>> updateBuffer = [];
                  final List<Product> buffer = [];
                  finalSellMap.forEach((item, value) {
                    final Product newProduct =
                        Product()
                          ..id = item.id
                          ..name = item.name
                          ..model = item.model
                          ..description = item.description
                          ..count = item.count
                          ..compatibleList = item.compatibleList;
                    newProduct.count -= value;
                    buffer.add(newProduct);
                  });
                  buffer.forEach((product) {
                    updateBuffer.add(
                      Provider.of<ProductDatabase>(
                        context,
                        listen: false,
                      ).updateProduct(product),
                    );
                  });
                  await LoadingDialog.show(context, updateBuffer);
                  setState(() {
                    finalSellMap.clear();
                  });
                },
                child: Text(
                  'Zapisz i zaktualizuj stany',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
