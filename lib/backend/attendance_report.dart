import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> generateAttendanceReport(
  DateTime startDate, DateTime endDate) async {
  
  DatabaseHelper db = DatabaseHelper();
  final attendanceData = await db.fetchAttendanceRange(startDate, endDate);
  // If no data found, return early
  if (attendanceData.isEmpty) {
    //print("No attendance records found for the specified date range.");
    return;
  }

  // Convert the data into a CSV format
  List<List<String>> csvData = [
    ['Id del Alumno', 'Nombre', 'fecha', 'Estado'],
  ];

  attendanceData.forEach((row) {
    csvData.add([
      row['userId'].toString(),
      row['name'].toString(),
      row['date'].toString(),
      row['status'].toString(),
    ]);
  });

  // Generate CSV
  String csvContent = const ListToCsvConverter().convert(csvData);
  
  Future<bool> _requestPermision() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If permission is not granted, request it
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      print("Permission granted");
      return true;
      // Proceed with writing to external storage
    } else if (status.isDenied) {
      print("Permission denied");
      return false;
      // Handle the case where the user denies the permission
    } else if (status.isPermanentlyDenied) {
      // Open app settings so the user can manually enable the permission
      await openAppSettings();
      return true;
    }
    return false;
  }

  if (await _requestPermision()){
    Directory? directory = await getExternalStorageDirectory();
  
    if (directory != null) {
      String path = directory.path;
      print(path);
      List<String> folders = path.split('/');
      String new_path = '';
      for (var i = 1; i < folders.length; i++) {
        if (folders[i]=='Android'){
          break;
        }else{
          new_path += '/' + folders[i]; 
        }
      } 
      
      new_path += '/La_Dinamica_Folder';
      print(new_path);
      if (await Directory(new_path).exists()) {
        // File file = File('$path/attendance_report.csv');
        // await file.writeAsString(csvContent);
      print("CSV report generated at: ${new_path}");
      }else{
      Directory(new_path).create();
      print('Directorio creado en $new_path'); 
      }
    }
    }
  // Save CSV file to device
  
}
