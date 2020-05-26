import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluter_vscode/model/client_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class ClientDatabaseProvider{

    ClientDatabaseProvider._();
    Database _database; //instanciamos el data base para usarlo
    String basededatos = "Client.db";
    String tabla = "Client";

static final ClientDatabaseProvider db = ClientDatabaseProvider._();

//para evitar varias conecciones una y otra vez 

Future<Database> get database async{
  if(_database != null) return _database;
  _database = await getDatabaseInstanace();
  return _database;
}//evitamos varias apertura de base de datos

//aqui creamos la base de datos y hacemos el query
Future<Database> getDatabaseInstanace() async{
  Directory directory = await getApplicationDocumentsDirectory();
  String path = join(directory.path, basededatos); // le asignamos nombre ala base de datos 
  return await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async{
      await db.execute("CREATE TABLE " + tabla + " (" //ejecutamos el query para crear la tabla con sus atributos
        "id integer primary key,"
        "name TEXT,"
        "phone TEXT"
      ")");
    });
}//creacion de la base de datos

//query a la base de datos
//mostrar todos los clientes
Future<List<Client>> getAllClients() async{
  final db = await database;
  var response = await db.query(tabla);
  List<Client> list = response.map((e) => Client.fromMap(e)).toList();
  return list;
}

//query a la base de datos
//mostrar un solo cliente
Future<Client> getClientWithId(int id) async{
  final db = await database;
  var response = await db.query(tabla, where: "id = ?", whereArgs: [id]);
  return response.isNotEmpty ? Client.fromMap(response.first) : null;
}//mostrar un solo cliente

//insert
addClientToDatabase(Client client) async{
  final db = await database;
  var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM "+tabla);
  int id = table.first["id"];
  client.id = id;
  var raw = await db.insert(tabla, client.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  return raw;
}//finaliza insert

//delete 
deleteClientWithId(int id) async{
  final db = await database;
  return db.delete(tabla, where: "id = ?", whereArgs: [id]);
}

//delete all client

deleteAllClient() async{
  final db = await database;
  db.delete(tabla);
}

//update 
updateClient(Client client) async{
  final db = await database;
  var response = await db.update(tabla, client.toMap(),
  where: "id = ?", whereArgs: [client.id]);
  return response;
}

}