import 'package:flutter/material.dart';
import 'package:local_database/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/category_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Notes.db";

  static const _tableName = 'Note';
  static const _itemColumnId = 'id';
  static const _itemColumnTitle = 'title';
  static const _itemColumnDescription = 'description';
  static const _itemColumnCategoryName = 'categoryName';
  static const _itemColumnCategoryId = 'itemCategoryId';
  static const _itemColumnDate = 'date';

  static const String _categoryDbName = "Category.db";

  static const _categoryTableName = 'Category';
  static const _categoryColumnId = 'categoryId';
  static const _categoryColumnTitle = 'categoryTitle';


  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE $_tableName($_itemColumnId INTEGER PRIMARY KEY,"
                " $_itemColumnTitle TEXT NOT NULL, $_itemColumnDescription TEXT NOT NULL, $_itemColumnCategoryName TEXT NOT NULL,$_itemColumnCategoryId INTEGER NOT NULL, $_itemColumnDate TEXT NOT NULL);"),
        version: _version);
  }

  static Future<Database> getCategoryDB() async {
    return openDatabase(join(await getDatabasesPath(), _categoryDbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE $_categoryTableName($_categoryColumnId TEXT  NOT NULL, $_categoryColumnTitle TEXT NOT NULL);"),
        version: _version);
  }

  static Future<void> insertCategories(Database db) async {

    List<Map<String, dynamic>> categories = [
      {'categoryId': 1, 'categoryTitle': 'Food'},
      {'categoryId': 2, 'categoryTitle': 'Shapes'},
      {'categoryId': 3, 'categoryTitle': 'Clothes'}
    ];

    categories.forEach((category) async {
      await db.insert(
        _categoryTableName,
        category,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

  }

  static Future<int> addNote(Item note) async {
    final db = await _getDB();
    return await db.insert(_tableName, note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(Item note) async {
    final db = await _getDB();
    return await db.update(_tableName, note.toJson(),
        where: '$_itemColumnId = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(Item note) async {
    final db = await _getDB();
    return await db.delete(
      _tableName,
      where: '$_itemColumnId = ?',
      whereArgs: [note.id],
    );
  }

  static Future<List<Item>?> getAllNotes() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    if (maps.isEmpty) {
      return null;
    }else{
      debugPrint(maps.map((e) => e.values).toString());
    }
    return List.generate(maps.length, (index) => Item.fromJson(maps[index]));
  }

  static Future<List<Map<String, dynamic>>?> getCategories() async {
    final db = await getCategoryDB();

    final List<Map<String, dynamic>> maps = await db.query(_categoryTableName);
    if (maps.isEmpty) {
      return null;
    }else{
      //print(maps.map((e) => e.values));
    }

    return maps;
    //return List.generate(maps.length, (index) => CategoryModelData.(maps[index]));
  }


  ///to query specific data
  static Future<List<Item>?> getSpecific(int categoryId,String date) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = categoryId==4? await db.query(_tableName,where: '$_itemColumnDate = ?',whereArgs: [date]) : await db.query(_tableName,where: '$_itemColumnDate = ? AND $_itemColumnCategoryId = ?',whereArgs: [date,categoryId]);
    if (maps.isEmpty) {
      return null;
    }else{
      debugPrint(maps.map((e) => e.values).toString());
    }
    return List.generate(maps.length, (index) => Item.fromJson(maps[index]));
  }

}
