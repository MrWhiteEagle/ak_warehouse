import 'package:ak_warehouse/database/product.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static final IsarService instance = IsarService.internal();
  late Isar isar;

  IsarService.internal();

  factory IsarService() {
    return instance;
  }

  Future<void> openIsar() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open([ProductSchema], directory: dir.path);
      debugPrint('[ISAR] Database initialized!');
    } catch (e) {
      debugPrint('[ISAR] Failed to initialize database: $e');
    }
  }

  bool get isIsarOpen => isar.isOpen;
}
