import 'package:ak_warehouse/database/product.dart';
import 'package:flutter/material.dart';

Future<Compatible?> createCompatibleItemDialog(
  BuildContext context, {
  String? initalProducer,
  String? initialModel,
}) {
  final prodCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  if (initalProducer != null && initialModel != null) {
    prodCtrl.text = initalProducer;
    modelCtrl.text = initialModel;
  }
  return showDialog<Compatible>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(
            'Dodaj kompatybilny produkt',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: prodCtrl,
                decoration: InputDecoration(
                  label: Text('Producent'),
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
              TextField(
                controller: modelCtrl,
                decoration: InputDecoration(
                  label: Text('Model'),
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
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Anuluj'),
            ),
            MaterialButton(
              onPressed: () {
                if (prodCtrl.text.isNotEmpty && modelCtrl.text.isNotEmpty) {
                  final item =
                      Compatible()
                        ..producer = prodCtrl.text
                        ..model = modelCtrl.text;
                  Navigator.of(context).pop(item);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nie wypełniono wszystkich pól')),
                  );
                }
              },
              child: Text(
                'Zapisz',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
  );
}
