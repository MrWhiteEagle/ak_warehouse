import 'package:ak_warehouse/database/product.dart';
import 'package:flutter/material.dart';

Future<Product?> addItemDialog(BuildContext context, List<Product> list) {
  return showDialog<Product?>(
    context: context,
    builder: (context) {
      Product? pickedItem;
      return AlertDialog(
        title: Text(
          'Dodaj produkt',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        content: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Wybierz:',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            DropdownMenu<Product>(
              dropdownMenuEntries:
                  list.map((item) {
                    return DropdownMenuEntry<Product>(
                      value: item,
                      label: item.name,
                    );
                  }).toList(),
              onSelected: (value) {
                pickedItem = value;
              },
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Anuluj', style: TextStyle(fontSize: 18)),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(pickedItem);
            },
            child: Text(
              'Zapisz',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
