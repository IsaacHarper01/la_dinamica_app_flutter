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
        email TEXT,
        image TEXT
      )
    ''');
      await db.execute('''
        CREATE TABLE Payments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          amount REAL NOT NULL,
          clases INT NOT NULL,
          type TEXT NOT NULL,
          date TEXT NOT NULL,
          UNIQUE(userId,date,amount)
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
    } catch (e) {
    }
    await db.close();
    
  } 

  Future<int> InsertGeneralData(Map<String, dynamic> row) async{
    final db = await _openDatabase();
    await db.insert('General', row);
    final data = await db.query('General',where: 'name = ?',whereArgs: [row['name']]);
    final int id = data[0]['id'] as int;
    await db.close();
    return id;
  }

  Future<void> InserPaymentData(Map<String, dynamic> row) async{
    final db = await _openDatabase();
    try {
      await db.insert('Payments', row);
    } catch (e) {
      print('Pago ya registrado');
    }
    
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
      min.toString().split(' ')[0],
      max.toString().split(' ')[0],
        ],
      );
    await db.close();
    return data;
  }

  Future<List<Map<String,dynamic>>> fetchPaymentsRange(DateTime min, DateTime max) async{
    final db = await _openDatabase();
    final List<Map<String, dynamic>> data = await db.query('Payments', where: 'date BETWEEN ? AND ?',
    whereArgs: [
      min.toString().split(' ')[0],
      max.toString().split(' ')[0],
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
    List<dynamic> images = data.map((element)=>element['image']).toList();
    //InserAttendancetData({'userID': 3,'name': 'Isaac Hernandez', 'date':DateTime.now().toString().split(' ')[0],'status':'Presente'});
    //InserAttendancetData({'userID': 4,'date':'2024-09-06','status':'presente'});
    //DateTime startDate = DateTime(2024, 10, 01);
    //DateTime endDate = DateTime(2024, 10, 03);
    //final DateTime maximun = DateTime.;
    //fetchAttendanceRange(startDate, endDate);
    //deleteRegister(4, 'Attendance');
    //generateAttendanceReport(startDate, endDate);
    //generateCredentialandSend(4, 'Uriel Javier Carranza Lopez', 'San Martin', '554203659', '12', '/data/user/0/com.example.la_dinamica_app/app_flutter/Alex Marin.jpg');
    //deleteDB();
    //fetchPaymentsData();
    //varifyPay(0);
    //deleteTable('Payments');
    await db.close();
    return({'ids':ids,'names':names,'emails':emails,'phones':phones,'address':address,'ages':ages,'birthdays':birthdays,'images':images});
  }

  Future<List<Map<String,dynamic>>> fetchMetricsData()async{
    final db = await _openDatabase();
    final data = await db.query('Metrics');
    await db.close();
    return data;
  }

  Future<List<Map<String,dynamic>>> fetchPlansData()async{
    final db = await _openDatabase();
    final data = await db.query('Plans');
    await db.close();
    return data;
  }


//FETCH A SINGLE DATA FROM TABLE
  Future<List<List<String>>> fetchAges(List<int> ids)async{
    final db = await _openDatabase();
    final List<String> ages= [];
    final List<String> address=[];
    for (var id in ids) {
      var data = await db.query('General',where: 'id = ?',whereArgs: [id]);
      ages.add(data[0]['age'] as String);
      address.add(data[0]['address'] as String);
    }
    return [ages,address];
  }

  Future<Object?> fetchSimpleData(String table, String field, int id, bool allfields)async{
    final db = await _openDatabase();
    final data = await db.query(table, where: 'id LIKE ?', whereArgs: [id],);
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
    
    List<dynamic> ids = data.map((elemet) => elemet['userId']).toList();
    List<dynamic> names = data.map((element) => element['name']).toList();
    List<String?> images=[];
    for (var id in ids) {
      final List<Map<String, dynamic>> result= await db.query('General',columns: ['image'],where: 'id = ?',whereArgs: [id]);
      if (result.isNotEmpty) {
      // If there is an image for the ID, add the image path to the list
      images.add(result[0]['image'] as String?);
    } else {
      // If no image is found for the ID, add null or handle it as needed
      images.add(null);
    }
  }
    await db.close();
    return ({'ids':ids,'names':names,'images':images});
  }

  Future<double> fetchIncomeRange(String start,String? end)async{
    final db = await _openDatabase();
    double result = 0.0;
    List<Map<String,Object?>> data=[];

    if (end==null || end==start) {  
      data = await db.query(
      'Payments',
      columns: ['amount'],
      where: 'date LIKE ?',
      whereArgs: [start + '%'], // % to account for time in the string
    );  
    }else{
      data = await db.query(
      'Payments',
      columns: ['amount'],
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start + '%',end + '%'], // % to account for time in the string
      ); 
    }
  for (var element in data) {
    result += element['amount'] as double;
  }
  return result; 
  }

  Future<List<List<String>>> fetchNamesIdsPlans() async {
  final db = await _openDatabase();

  final names = await db.query('General', columns: ['name']); 
  final ids = await db.query('General', columns: ['id']);
  final plans = await db.query('Plans');

  List<String> namesList = names.map((e) => e['name'].toString()).toList();
  List<String> idsList = ids.map((e) => e['id'].toString()).toList();
  List<String> plantype = plans.map((e) => e['type'].toString()).toList();
  List<String> planprice = plans.map((e) => e['price'].toString()).toList();
  List<String> num_class = plans.map((e)=>e['clases'].toString()).toList();
  
  return [namesList, idsList, plantype, planprice, num_class];
}

  Future<Map<String, dynamic>?> fetchLastPayment(int userId) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> results = await db.query('Payments',where: 'userId = ?', whereArgs: [userId],orderBy: 'id DESC',limit: 1,);
    return results.isNotEmpty ? results.first : null;
}

  Future<Map<String, dynamic>?> fetchLastPayandStudentlData(int userId) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> lastPay = await db.query('Payments',where: 'userId = ?', whereArgs: [userId],orderBy: 'id DESC',limit: 1,);
    final List<Map<String,dynamic>> studentData = await db.query('General',where: 'id = ?',whereArgs: [userId]);
    return {
    'lastPay': lastPay.isNotEmpty ? lastPay.first : {},
    'studentData': studentData.isNotEmpty ? studentData.first : {}
  };
  
}

  Future<Map<String, dynamic>?> fetchBasePayment() async {
      final db = await _openDatabase();
      final List<Map<String, dynamic>> results = await db.query('Plans',where: 'clases = 1',limit: 1,);
      return results[0].isNotEmpty ? results.first : null;
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

  Future<void> deleteAttendance(int id, String date)async{
    final Database db = await _openDatabase();
    db.delete('Attendance',where: 'userId = ? AND date = ?',whereArgs: [id,date]);
    db.delete('Payments',where: 'userId = ? AND date = ?',whereArgs: [id,date]); 
  }

  Future<void> deleteStudentPlan(int id)async{
    final Database db = await _openDatabase();
    final pay = {"userId": id,
                "amount":0,
                "clases":0,
                "type": 'Cancelacion',
                "date": DateTime.now().toString().split(' ')[0]};
    db.insert('Payments', pay);
  }

//UPDATE VALUES

  Future<void> updateClases(int Id, int remainingClases) async {
    final db = await _openDatabase();
    await db.update('Payments', {'clases': remainingClases}, where: 'id = ?', whereArgs: [Id],);
  }

  Future<void> varifyPay(int userId) async{
    var lastPay = await fetchLastPayment(userId);
    var basePayment = await fetchBasePayment();
    double cost = basePayment!['price'];
    String date = DateTime.now().toString().split(' ')[0];
    Map<String,dynamic> pay;
    if (lastPay==null) {
      pay = {'userId':userId,'amount':cost,'clases':0,'type':basePayment['type'],'date':date};
      InserPaymentData(pay);
      return;
    }else if ((lastPay['type']!=basePayment['type']) && (lastPay['clases']>0)) {
      var id = lastPay['id'];
      var remainingClases = lastPay['clases']-1;
      updateClases(id, remainingClases);
    }else{
      pay = {'userId':userId,'amount':cost,'clases':0,'type':basePayment['type'],'date':date};
      InserPaymentData(pay);
    }
  }

}


