import 'package:ak_warehouse/database/product.dart';
import 'package:ak_warehouse/database/product_database.dart';
import 'package:ak_warehouse/dialogs/create_compatible_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final nameCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final countCtrl = TextEditingController();
  List<Compatible> compList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        title: Text(
          'Dodaj produkt',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              maxLines: 1,
              maxLength: 40,
              decoration: InputDecoration(
                label: Text('Nazwa'),
                labelStyle: TextStyle(
                  color:
                      Color.lerp(
                        Theme.of(context).colorScheme.primary,
                        Colors.grey,
                        0.6,
                      )!,
                ),
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.grey,
                          0.6,
                        )!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: modelCtrl,
              maxLines: 1,
              maxLength: 40,
              decoration: InputDecoration(
                label: Text('Nr/Model'),
                labelStyle: TextStyle(
                  color:
                      Color.lerp(
                        Theme.of(context).colorScheme.primary,
                        Colors.grey,
                        0.6,
                      )!,
                ),
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.grey,
                          0.6,
                        )!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              maxLines: 7,
              controller: descCtrl,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                label: Text('Opis'),
                labelStyle: TextStyle(
                  color:
                      Color.lerp(
                        Theme.of(context).colorScheme.primary,
                        Colors.grey,
                        0.6,
                      )!,
                ),
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.grey,
                          0.6,
                        )!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Aktualny stan magazynu:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.lerp(
                          Theme.of(context).colorScheme.primary,
                          Colors.black,
                          0.3,
                        ),
                      ),
                    ),
                    Text(
                      'Puste = 0',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    controller: countCtrl,
                    decoration: InputDecoration(
                      label: Text('Ilość/Stan'),
                      labelStyle: TextStyle(
                        color:
                            Color.lerp(
                              Theme.of(context).colorScheme.primary,
                              Colors.grey,
                              0.6,
                            )!,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              Color.lerp(
                                Theme.of(context).colorScheme.primary,
                                Colors.grey,
                                0.6,
                              )!,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Kompatybilne produkty',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final item = await createCompatibleItemDialog(context);
                        if (item != null) {
                          setState(() {
                            compList.add(item);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      iconAlignment: IconAlignment.end,
                      label: Text(
                        'Dodaj',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child:
                  compList.isEmpty
                      ? Center(child: Text('Brak kompatybilnych produktów'))
                      : ListView.builder(
                        itemCount: compList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            style: ListTileStyle.drawer,
                            title: Text(compList[index].producer!),
                            subtitle: Text(compList[index].model!),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  List<Compatible> newList = List.from(
                                    compList,
                                  );
                                  newList.remove(compList[index]);
                                  compList.clear();
                                  compList.addAll(newList);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
            ),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Anuluj'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameCtrl.text.isNotEmpty) {
                          final newProduct =
                              Product()
                                ..name = nameCtrl.text
                                ..model = modelCtrl.text
                                ..description = descCtrl.text
                                ..count = int.parse(countCtrl.text)
                                ..compatibleList = compList;
                          debugPrint(
                            newProduct.name +
                                newProduct.description +
                                newProduct.model +
                                newProduct.count.toString() +
                                newProduct.compatibleList.toString() +
                                newProduct.id.toString(),
                          );
                          await Provider.of<ProductDatabase>(
                            context,
                            listen: false,
                          ).createProduct(newProduct);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nazwa nie może być pusta!'),
                            ),
                          );
                        }
                      },
                      child: Text('Zapisz'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
