import 'package:isar/isar.dart';

part 'product.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;
  late String name;
  late String model;
  late String description;
  late int count;
  List<Compatible> compatibleList = [];
}

@embedded
class Compatible {
  String? producer;
  String? model;
}
