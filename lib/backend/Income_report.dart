import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';


Future<void> generateIncomeReport(DateTime min, DateTime max) async {

  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  DatabaseHelper db = DatabaseHelper();
  final paymentsData = await db.fetchPaymentsRange(min, max);
  
  if (paymentsData.isEmpty) {
    return;
  }

  List<List<String>> csvData = [
    ['Id del Alumno', 'Fecha', 'Concepto','Monto']
  ];
  num total = 0;
  for (var pay in paymentsData) {
    total += pay['amount'];
    csvData.add([
      pay['userId'].toString(),
      pay['date'].toString(),
      pay['type'].toString(),
      pay['amount'].toString(),
    ]);
  }

  csvData.add(['Total','${min.toString().split(' ')[0]} - ${max.toString().split(' ')[0]}', '', '$total']);

  // Generar contenido CSV
  String csvContent = const ListToCsvConverter().convert(csvData);
  // Obtener el directorio público de descargas
  Directory? directory = (await getTemporaryDirectory());

  String path = directory.path;
  String fileName = '$path/income_report_${DateTime.now().toString().split(' ')[0]}.csv';
  File file = File(fileName);
  await file.writeAsString(csvContent);

  await Share.shareXFiles([XFile(fileName)], text: 'Attendance report');
}