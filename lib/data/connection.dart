import 'package:flutter_dotenv/flutter_dotenv.dart';


const mongoConUrl = "mongodb://atlas-sql-66791594be00f13d62caf252-4dcjo.a.query.mongodb.net/myVirtualDatabase?ssl=true&authSource=admin";
const userConnection = "News";

const name = "newszen_database";
var password = dotenv.env['MONGODB_PASSWORD'];