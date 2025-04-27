import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.changePage});
  final Function(int index) changePage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Image.asset('assets/kbwy_name_logo.png'),
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text('Katalog produktów', style: TextStyle(fontSize: 18)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                changePage(0);
                Navigator.pop(context);
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text('Magazyn', style: TextStyle(fontSize: 18)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                changePage(1);
                Navigator.pop(context);
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text('Sprzedaż', style: TextStyle(fontSize: 18)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                changePage(2);
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(color: Colors.grey),
                  ListTile(
                    title: Text('Resetowanie', style: TextStyle(fontSize: 18)),
                    trailing: Icon(Icons.warning_outlined, color: Colors.grey),
                    onTap: () {
                      changePage(3);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color: Colors.grey),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
