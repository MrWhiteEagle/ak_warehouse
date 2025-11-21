import 'dart:io';

import 'package:ak_warehouse/database/product.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class IsarService {
  static final IsarService instance = IsarService.internal();
  late Isar isar;

  IsarService.internal();

  factory IsarService() {
    return instance;
  }

  Future<void> openIsar() async {
    try {
      final dir = Directory.current.path;
      final logDir = Directory.current.path;
      final logFile = File('$logDir\\log.txt');
      logFile.writeAsStringSync(dir.toString());
      print("logfile is at $logDir");
      isar = await Isar.open([ProductSchema], directory: dir);
      debugPrint('[ISAR] Database initialized!');
    } catch (e) {
      debugPrint('[ISAR] Failed to initialize database: $e');
    }
  }

  Future<void> closeIsar() async {
    if (isar.isOpen) {
      isar.close();
    }
  }

  bool get isIsarOpen => isar.isOpen;
}
