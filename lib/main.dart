import 'package:ak_warehouse/database/isar_service.dart';
import 'package:ak_warehouse/database/product.dart';
import 'package:ak_warehouse/database/product_database.dart';
import 'package:ak_warehouse/pages/create_product_page.dart';
import 'package:ak_warehouse/pages/subpages/reset_page.dart';
import 'package:ak_warehouse/pages/subpages/sell_page.dart';
import 'package:ak_warehouse/pages/subpages/catalogue_page.dart';
import 'package:ak_warehouse/pages/subpages/warehouse_page.dart';
import 'package:ak_warehouse/theme/app_theme.dart';
import 'package:ak_warehouse/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() async {
  await IsarService().openIsar();
  WidgetsFlutterBinding.ensureInitialized();

  setWindowTitle('KEYBOARDWAY MAGAZYN');
  setWindowMinSize(Size(720, 1000));
  runApp(
    ChangeNotifierProvider<ProductDatabase>(
      create: (_) => ProductDatabase(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void dispose() {
    IsarService().closeIsar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageController(),
      theme: regular(),
    );
  }
}

class PageController extends StatefulWidget {
  const PageController({super.key});

  @override
  State<PageController> createState() => _PageControllerState();
}

class _PageControllerState extends State<PageController> {
  late int index;
  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: actionButton(index, context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Magazyn KEYBOARDWAY',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        leading: Builder(
          builder:
              (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
        ),
      ),
      drawer: MainDrawer(
        changePage:
            (i) => setState(() {
              //on normal page change - revert selectedproduct to null
              selectedProduct = null;
              index = i;
            }),
      ),
      body: pages(
        index,
        onSellPageRequested: (Product product) {
          //on receiver product sell request - change page to sellpage and set a selected product to pass to it
          setState(() {
            index = 2;
            selectedProduct = product;
          });
        },
        product: selectedProduct,
      ),
    );
  }
}

Widget pages(
  index, {
  required Function(Product) onSellPageRequested,
  Product? product,
}) {
  switch (index) {
    case 0:
      return Catalogue(onSellPageRequested: onSellPageRequested);
    case 1:
      return Warehouse();
    case 2:
      if (product == null) {
        return SellPage();
      } else {
        return SellPage(initialP: product);
      }
    case 3:
      return ResetPage();
    default:
      return Catalogue(onSellPageRequested: onSellPageRequested);
  }
}

Widget? actionButton(index, context) {
  switch (index) {
    case 0:
      return null;
    case 1:
      return FloatingActionButton.extended(
        isExtended: true,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductPage()),
          ).then(
            (_) =>
                Provider.of<ProductDatabase>(
                  context,
                  listen: false,
                ).fetchAllProducts(),
          );
        },
        tooltip: 'Dodaj produkt',
        icon: Icon(Icons.add),
        label: Text('Dodaj produkt'),
      );
    default:
      return null;
  }
}
