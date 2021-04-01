import 'dart:convert';

import 'package:flutter/material.dart';

class Item{
  final String id;
  final String itemname;
  final String itemprice;
  final String itemimage;
  final String itemdescribe;
  final String itemid;

  Item({this.id, this.itemname, this.itemprice, this.itemimage,
      this.itemdescribe, this.itemid});

  factory Item.fromJson(Map<String, dynamic> json) {
    return new Item(
        id: json['id'],
        itemname: json['itemname'],
        itemprice: json['itemprice'],
        itemimage: json['itemimage'],
        itemdescribe: json['itemdescribe'],
        itemid: json['itemid']
    );
  }

  static List<Item> parseItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Item>((json) => Item.fromJson(json)).toList();
  }
}
