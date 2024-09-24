import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> generateAttendanceReport(DateTime startDate, DateTime endDate) async {
  
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  DatabaseHelper db = DatabaseHelper();
  final attendanceData = await db.fetchAttendanceRange(startDate, endDate);
  // If no data found, return early
  if (attendanceData.isEmpty) {
    print("No attendance records found for the specified date range.");
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

  // Save CSV file to device
  Directory? directory = await getExternalStorageDirectory();
  if (directory != null) {
    String path = directory.path;
    File file = File('$path/attendance_report.csv');
    await file.writeAsString(csvContent);
    print("CSV report generated at: ${path}");
  }else{
    print('Could not find an external storage directory');
  }

}