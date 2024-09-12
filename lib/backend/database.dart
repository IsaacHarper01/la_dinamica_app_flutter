import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper{

//CREATE DATABASE

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
        clases INT,
        type TEXT,
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
        userId INTEGER NOT NULL,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        UNIQUE(userId,date)
      )
    ''');
    await db.execute('''
      CREATE TABLE Plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        clases INT,
        price FLOAT
      )
    ''');
      },version: 1
    );
  }

///INSERTS

  Future<void> InserAttendanceData(int id, String name) async{
    final db = await _openDatabase();
    final today_date = DateTime.now().toString().split(' ')[0];
    Map<String, dynamic> row = {'userId':id,'name':name,'date':today_date,'status':'Presente'};
    try {
      await db.insert('Attendance', row);
      print('Asistencia registrada');
    } catch (e) {
      print('Asistencia ya registrada');
    }
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

  Future<void> InsertPlanData(Map<String, dynamic> row) async{
    final db = await _openDatabase();
    await db.insert('Plans', row);
    await db.close();
  }

///FETCH ALL DATA

  Future<List<Map<String,dynamic>>> fetchAttendanceRange(DateTime min, DateTime max) async{
    final db = await _openDatabase();
    final List<Map<String, dynamic>> data = await db.query('Attendance', where: 'date BETWEEN ? AND ?',
    whereArgs: [
      min.toIso8601String(),
      max.toIso8601String(),
        ],
      );
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
    //InserAttendancetData({'userID': 3,'name': 'Isaac Hernandez', 'date':DateTime.now().toString().split(' ')[0],'status':'Presente'});
    //InserAttendancetData({'userID': 4,'date':'2024-09-06','status':'presente'});
    //DateTime startDate = DateTime(2024, 9, 10);
    //DateTime endDate = DateTime(2024, 9, 15);
    //final DateTime maximun = DateTime.;
    //fetchAttendanceRange(startDate, endDate);
    //deleteRegister(4, 'Attendance');
    //deleteDB();
    //print(fetchAttendanceToday());
    //print(fetchSimpleData('General', 'name', 2, false));
    await db.close();
    return({'ids':ids,'names':names,'emails':emails,'phones':phones,'address':address,'ages':ages,'birthdays':birthdays});
  }

  Future<List<Map<String,dynamic>>> fetchMetricsData()async{
    final db = await _openDatabase();
    final data = await db.query('Metrics');
    await db.close();
    return data;
  }

//FETCH A SINGLE DATA FROM TABLE
 
  Future<Object?> fetchSimpleData(String table, String field, int id, bool allfields)async{
    final db = await _openDatabase();
    final data = await db.query('General', where: 'id LIKE ?', whereArgs: [id],);
    if (data.isNotEmpty) {
    if (allfields) {
      return data[0]; // Returns Map<String, dynamic>
    } else {
      return data[0][field]; // Returns dynamic (e.g., String, int)
    }
    }else {
    return null; // Handle the case where no data is found
    }
  }

  Future<Map<String,dynamic>> fetchAttendanceToday()async{
    final db = await _openDatabase();
    final today = DateTime.now().toString().split(' ')[0];
    final data = await db.query(
      'Attendance',
      where: 'date LIKE ? AND status = ?',
      whereArgs: [today + '%','Presente'], // % to account for time in the string
    );
    await db.close();
    List<dynamic> ids = data.map((elemet) => elemet['userId']).toList();
    List<dynamic> names = data.map((element) => element['name']).toList();
  
    return ({'ids':ids,'names':names});
  }

//DELETE FUNCTIONS

  Future<int> deleteRegister(int id, String? table) async{
    final db = await _openDatabase();
    if (table == 'General') {return db.delete('General',where: 'id=?',whereArgs: [id]);}
    else if(table=='Payments'){return db.delete('Payments',where: 'id=?',whereArgs: [id]);}
    else if(table=='Attendance'){return db.delete('Attendance',where: 'id=?',whereArgs: [id]);}
    else if(table=='Metrics'){return db.delete('Metrics',where: 'id=?',whereArgs: [id]);}
    else{
      db.delete('General',where: 'id=?',whereArgs: [id]);
      db.delete('Payments',where: 'id=?',whereArgs: [id]);
      db.delete('Attendance',where: 'id=?',whereArgs: [id]);
      return db.delete('Metrics',where: 'id=?',whereArgs: [id]);
    }
  }

  Future<void> deleteTable(String table)async{
  final db = await _openDatabase();
  db.delete(table);
  print('Table $table deleted succesfully');
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'alumnos.db');

    // Delete the database
    await deleteDatabase(path);
    print('Database deleted');
  }
}