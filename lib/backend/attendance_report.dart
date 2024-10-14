import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

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
  Directory? directory = (await getTemporaryDirectory());

  String path = directory.path;
  String fileName = '$path/attendance_report_${DateTime.now().toString().split(' ')[0]}.csv';
  File file = File(fileName);
  await file.writeAsString(csvContent);

  await Share.shareXFiles([XFile(fileName)], text: 'Attendance report');
}