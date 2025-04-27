import 'package:ak_warehouse/database/product_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPage extends StatelessWidget {
  const ResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Zresetuj bazę danych:',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              resetConfirmDialog(context);
            },
            label: Text(
              'RESET',
              style: TextStyle(
                color: Color.lerp(
                  Theme.of(context).colorScheme.error,
                  Colors.black,
                  0.3,
                ),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void resetConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(
            'NA PEWNO?',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Spowoduje to wymazanie wszystkich danych z aplikacji!',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Anuluj', style: TextStyle(fontSize: 18)),
            ),
            MaterialButton(
              onPressed: () async {
                await Provider.of<ProductDatabase>(
                  context,
                  listen: false,
                ).resetProductDatabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Zresetowano bazę danych')),
                );
              },
              child: Text(
                'RESETUJ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
  );
}
