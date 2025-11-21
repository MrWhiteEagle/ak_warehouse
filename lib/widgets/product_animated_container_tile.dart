import 'package:ak_warehouse/database/product.dart';
import 'package:ak_warehouse/database/product_database.dart';
import 'package:ak_warehouse/dialogs/are_you_sure.dart';
import 'package:ak_warehouse/pages/edit_product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductAnimatedContainerTile extends StatelessWidget {
  const ProductAnimatedContainerTile({
    super.key,
    required this.expandedIndexes,
    required this.tileHeight,
    required this.expandedContentControl,
    required this.product,
    required this.db,
  });

  final List<Product> expandedIndexes;
  final double tileHeight;
  final List<Product> expandedContentControl;
  final Product product;
  final ProductDatabase db;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height:
          expandedIndexes.contains(product)
              ? calculateExpandedHeight(
                tileHeight,
                product.description,
                convertCompatibleToString(
                  product.compatibleList,
                ),
              )
              : tileHeight,
      duration: Duration(milliseconds: 130),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).colorScheme.primary,
          Colors.white,
          0.85,
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      //MAIN COLUMN ----------------------------
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        color: Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.black,
                          0.5,
                        ),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      product.model,
                      style: TextStyle(
                        color: Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.black,
                          0.5,
                        ),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Stan: ',
                    style: TextStyle(
                      color: Color.lerp(
                        Theme.of(context).colorScheme.primary,
                        Colors.black,
                        0.5,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    product.count.toString(),
                    style: TextStyle(
                      color: Color.lerp(
                        Theme.of(context).colorScheme.primary,
                        Colors.black,
                        0.5,
                      ),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder:
                                  (context) => EditProductPage(
                                    product: product,
                                  ),
                            ),
                          )
                          .then(
                            (_) =>
                                Provider.of<ProductDatabase>(
                                  context,
                                  listen: false,
                                ).searchProducts(""),
                          );
                    },
                    label: Text('Edytuj'),
                    icon: Icon(Icons.edit),
                  ),
                  TextButton.icon(
                    label: Text('Usuń'),
                    icon: Icon(Icons.delete_forever),
                    onPressed:
                        () => areYouSureDialog(
                          context,
                          product.id,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      expandedIndexes.contains(product)
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          if (expandedIndexes.contains(product) &&
              expandedContentControl.contains(product))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Opis:',
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                        Text(
                          product.description,
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kompatybilność:',
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                        Text(
                          convertCompatibleToString(
                            product.compatibleList,
                          ).join('\n'),
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 1),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ProductAnimatedContainerTileCatalogue extends StatelessWidget {
  const ProductAnimatedContainerTileCatalogue({
    super.key,
    required this.expandedIndexes,
    required this.tileHeight,
    required this.expandedContentControl,
    required this.product,
    required this.sellRequest,
  });

  final List<Product> expandedIndexes;
  final double tileHeight;
  final List<Product> expandedContentControl;
  final Product product;
  final Function(Product) sellRequest;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height:
          expandedIndexes.contains(product)
              ? calculateExpandedHeight(
                tileHeight,
                product.description,
                convertCompatibleToString(product.compatibleList),
              )
              : tileHeight,
      duration: Duration(milliseconds: 130),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).colorScheme.primary,
          Colors.white,
          0.85,
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      //MAIN COLUMN ----------------------------
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        color: Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.black,
                          0.5,
                        ),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      product.model,
                      style: TextStyle(
                        color: Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.black,
                          0.5,
                        ),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Stan: ',
                    style: TextStyle(
                      color: Color.lerp(
                        Theme.of(context).colorScheme.primary,
                        Colors.black,
                        0.5,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    product.count.toString(),
                    style: TextStyle(
                      color: Color.lerp(
                        Theme.of(context).colorScheme.primary,
                        Colors.black,
                        0.5,
                      ),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  sellRequest(product);
                },
                label: Text('Sprzedaż'),
                icon: Icon(Icons.sell),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  expandedIndexes.contains(product)
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (expandedIndexes.contains(product) &&
              expandedContentControl.contains(product))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Opis:',
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                        Text(
                          product.description,
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kompatybilność:',
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                        Text(
                          convertCompatibleToString(
                            product.compatibleList,
                          ).join('\n'),
                          style: TextStyle(height: 1, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 1),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

List<String> convertCompatibleToString(List<Compatible> list) {
  final List<String> output = [];
  for (var compatible in list) {
    output.add('${compatible.producer} ${compatible.model}');
  }
  return output;
}

double calculateExpandedHeight(
  double baseHeight,
  String desc,
  List<String> compatible,
) {
  int descLines = 1;
  int compLines = 1;
  double lineHeight = 16;
  for (var item in compatible) {
    compLines += 1;
  }
  descLines = desc.split('\n').length;
  if (descLines > compLines) {
    return lineHeight * descLines + baseHeight + 30;
  } else {
    return lineHeight * compLines + baseHeight + 30;
  }
}
