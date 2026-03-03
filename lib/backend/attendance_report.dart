import 'dart:io';

import 'package:csv/csv.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<void> generateAttendanceReport(
  DateTime startDate,
  DateTime endDate,
  String tenantId,
) async {
  // Solicitar permiso de almacenamiento
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  // Obtener los datos de asistencia desde la base de datos
  final awsDb = DataStoreReadService();

  final attendanceData = await awsDb.getAttendanceRange(startDate, endDate, tenantId);

  // Si no hay datos, salir
  if (attendanceData.isEmpty) {
    return;
  }
  final List<int> ids = [];

  for (var row in attendanceData) {
    ids.add(row.student!.user_id!);
  }

  final agesAndAddress = await awsDb.getAgesandAddress(ids, tenantId);

  List<List<String>> csvData = [
    ['Id del Alumno', 'Nombre', 'Edad', 'Localidad', 'Fecha'],
  ];

  for (var i = 0; i < attendanceData.length; i++) {
    csvData.add([
      attendanceData[i].student!.user_id.toString(),
      attendanceData[i].student!.name.toString(),
      agesAndAddress[0][i].toString(),
      agesAndAddress[1][i].toString(),
      attendanceData[i].date.toString(),
    ]);
  }

  // Generar contenido CSV
  String csvContent = const ListToCsvConverter().convert(csvData);
  // Obtener el directorio público de descargas
  Directory? directory = (await getTemporaryDirectory());

  String path = directory.path;
  String fileName =
      '$path/attendance_report_${DateTime.now().toString().split(' ')[0]}.csv';
  File file = File(fileName);
  await file.writeAsString(csvContent);

  await SharePlus.instance.share(
    ShareParams(subject: 'Reporte de asistencia', files: [XFile(fileName)]),
  );
}
