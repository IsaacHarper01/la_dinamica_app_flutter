import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> generateAttendanceReport(
    DateTime startDate, DateTime endDate) async {
  // Solicitar permiso de almacenamiento
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  // Obtener los datos de asistencia desde la base de datos
  DatabaseHelper db = DatabaseHelper();
  final attendanceData = await db.fetchAttendanceRange(startDate, endDate);

  // Si no hay datos, salir
  if (attendanceData.isEmpty) {
    return;
  }

  // Convertir los datos en formato CSV
  List<List<String>> csvData = [
    ['Id del Alumno', 'Nombre', 'Fecha', 'Estado'],
  ];

  attendanceData.forEach((row) {
    csvData.add([
      row['userId'].toString(),
      row['name'].toString(),
      row['date'].toString(),
      row['status'].toString(),
    ]);
  });

  // Generar contenido CSV
  String csvContent = const ListToCsvConverter().convert(csvData);

  // Obtener el directorio público de descargas
  Directory? directory = (await getExternalStorageDirectories(
    type: StorageDirectory.downloads,
  ))
      ?.first;

  if (directory != null) {
    String path = directory.path;
    File file = File(
        '$path/attendance_report_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvContent);

    // Imprimir la ubicación donde se generó el archivo
    print("CSV report generated at: $path");
  } else {
    print('No se pudo encontrar el directorio de descargas.');
  }
}
