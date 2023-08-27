import 'dart:developer';

import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper2 {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE carts(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        sku TEXT,
        name TEXT,
        thumb TEXT,
        price TEXT,
        quantity INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'q_soft.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(
      {required String sku,
      required String name,
      required String thumb,
        required String price,
      required int quantity}) async {
    final db = await SQLHelper2.db();

    final data = {
      'sku': sku,
      'name': name,
      'thumb': thumb,
      'price':price,
      'quantity': quantity
    };
    final id = await db.insert('carts', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getCarts() async {
    final db = await SQLHelper2.db();
    return db.query('carts', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem({required int id}) async {
    final db = await SQLHelper2.db();
    return db.query('carts', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      {required int id,
      required String sku,
      required String name,
      required String thumb,
      required String price,
      required int quantity}) async {
    final db = await SQLHelper2.db();

    final data = {
      'sku': sku,
      'name': name,
      'thumb': thumb,
      'price': price,
      'quantity': quantity,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('carts', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem({required int id}) async {
    final db = await SQLHelper2.db();
    try {
      await db.delete("carts", where: "id = ?", whereArgs: [id]);

    } catch (err) {
      log("Something went wrong when deleting an item: $err");
    }
  }
  //drop table
//await db.execute("DROP TABLE IF EXISTS tableName");
  static Future<void> dropData() async {
    final db = await SQLHelper2.db();
    try {
      await db.delete("carts");

    } catch (err) {
      log("Something went wrong when deleting an item: $err");
    }
  }
}
