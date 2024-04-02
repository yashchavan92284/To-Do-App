// import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:advancedtodo/main.dart';

dynamic database;

Future<void> insertodoData(ToDoModelClass obj) async {
  final localDB = await database;
  await localDB.insert(
    "Todo",
    obj.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> gettodoData() async {
  final localDB = await database;
  List<Map<String, dynamic>> mapEntry = await localDB.query(
    "Todo",
  );

  return mapEntry;
  // return List.generate(mapEntry.length, (i) {
  //   return ToDoModelClass(
  //       title: mapEntry[i]['title'],
  //       description: mapEntry[i]['description'],
  //       date: mapEntry[i]['date']);
  // });
}

Future<void> deleteData(int id) async {
  final localDB = await database;
  await localDB.delete(
    "Todo",
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<void> updateData(ToDoModelClass obj) async {
  final localDB = await database;

  localDB.update(
    "Todo",
    obj.toMap(),
    where: "id = ?",
    whereArgs: [obj.id],
  );
}