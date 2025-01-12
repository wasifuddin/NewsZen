import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import '../models/news_model.dart';




// const mongoConUrl = "mongodb://atlas-sql-66791594be00f13d62caf252-4dcjo.a.query.mongodb.net/myVirtualDatabase?ssl=true&authSource=admin";
// const mongoConUrl = "mongodb+srv://demo_user:tNwYzQbHbta4j_G@newszen.eup0l.mongodb.net/?retryWrites=true&w=majority&appName=Newszen";
//
// const userConnection = "News";
//
// const name = "newszen_database";
// var password = dotenv.env['MONGODB_PASSWORD'];


class MongoDatabase{
  static var db;

  static connect() async{
    db = await Db.create(MONGODB_CONNECTION);
    await db.open();
    inspect(db);
    var status = await db.serverStatus();
    // Fluttertoast.showToast(msg: status);

    var collection = db.collection(COLLECTION);
    print(await collection.find().toList());

    return collection;
  
  }
}
