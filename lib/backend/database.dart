import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper{
  var names = null;
  Future<Database> _openDatabase() async{
    final databasepath = await getDatabasesPath();
    final path = join(databasepath,'alumnos.db');
    
    return openDatabase(
      path,
      onCreate: (db, version) async{
      await db.execute('''
        CREATE TABLE General (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        address TEXT,
        phone TEXT,
        age TEXT,
        birthday TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        amount REAL,
        date TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE Metrics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        metric TEXT,
        date TEXT,
        value REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE Attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        date TEXT,
        status TEXT
      )
    ''');
      },version: 1
    );
  }
///INSERTS
///
  Future<void> InserAttendancetData(Map<String, dynamic> row) async{
    final db = await _openDatabase();
    await db.insert('Attendance', row);
    await db.close();
  } 

  Future<void> InsertGeneralData(Map<String, dynamic> row) async{
    final db = await _openDatabase();
    await db.insert('General', row);
    await db.close();
  }

  Future<void> InserPaymentData(Map<String, dynamic> row) async{
    final db = await _openDatabase();
    await db.insert('Payments', row);
    await db.close();
  }

  Future<void> InsertMetricsData(Map<String, dynamic> row) async{
    final db = await _openDatabase();
    await db.insert('Metrics', row);
    await db.close();
  }
///FETCH ALL DATA
///
  Future<List<Map<String,dynamic>>> fetchAttendanceData()async{
    final db = await _openDatabase();
    final data = await db.query('Attendance');
    await db.close();
    return data;
  }

  Future<List<Map<String,dynamic>>> fetchPaymentsData()async{
    final db = await _openDatabase();
    final data = await db.query('Payments');
    await db.close();
    return data;
  }

  Future<Map<String,dynamic>> fetchGeneralData()async{
    final db = await _openDatabase();
    final data = await db.query('General');
    List<dynamic> ids = data.map((element)=>element['id']).toList();
    List<dynamic> names = data.map((element)=>element['name']).toList();
    List<dynamic> emails = data.map((element)=>element['email']).toList();
    List<dynamic> phones = data.map((element)=>element['phone']).toList();
    List<dynamic> address = data.map((element)=>element['address']).toList();
    List<dynamic> ages = data.map((element)=>element['age']).toList();
    List<dynamic> birthdays = data.map((element)=>element['birthday']).toList();
    print(names.length);
    await db.close();
    return({'ids':ids,'names':names,'emails':emails,'phones':phones,'address':address,'ages':ages,'birthdays':birthdays});
  }

  Future<List<Map<String,dynamic>>> fetchMetricsData()async{
    final db = await _openDatabase();
    final data = await db.query('Metrics');
    await db.close();
    return data;
  }
  //this function could recive a string to indicate in which table will to delete the id
  //if the table parameter is not specified all the registers in all the tables will be delete
  Future<int> deleteRegister(int id, String? table) async{
    final db = await _openDatabase();
    if (table == 'General') {return db.delete('General',where: 'id=?',whereArgs: [id]);}
    else if(table=='Payments'){return db.delete('Payments',where: 'id=?',whereArgs: [id]);}
    else if(table=='Attendance'){return db.delete('Attendace',where: 'id=?',whereArgs: [id]);}
    else if(table=='Metrics'){return db.delete('Metrics',where: 'id=?',whereArgs: [id]);}
    else{
      db.delete('General',where: 'id=?',whereArgs: [id]);
      db.delete('Payments',where: 'id=?',whereArgs: [id]);
      db.delete('Attendance',where: 'id=?',whereArgs: [id]);
      return db.delete('Metrics',where: 'id=?',whereArgs: [id]);
    }
  }
}