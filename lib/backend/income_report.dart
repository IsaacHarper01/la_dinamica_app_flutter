import 'dart:io';

import 'package:csv/csv.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<void> generateIncomeReport(DateTime min, DateTime max, String tenantId) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  final awsDb = DataStoreReadService();

  final paymentsData = await awsDb.getPaymentsRange(min, max, tenantId);

  if (paymentsData.isEmpty) {
    return;
  }

  List<List<String>> csvData = [
    ['Id del Alumno', 'Fecha', 'Concepto', 'Monto'],
  ];
  num total = 0;
  for (var pay in paymentsData) {
    total += pay.amount!;
    csvData.add([
      pay.user_id.toString(),
      pay.date.toString(),
      pay.plan!.type.toString(),
      pay.amount.toString(),
    ]);
  }

  csvData.add([
    'Total',
    '${min.toString().split(' ')[0]} - ${max.toString().split(' ')[0]}',
    '',
    '$total',
  ]);

  // Generar contenido CSV
  String csvContent = const ListToCsvConverter().convert(csvData);
  // Obtener el directorio público de descargas
  Directory? directory = (await getTemporaryDirectory());

  String path = directory.path;
  String fileName =
      '$path/income_report_${DateTime.now().toString().split(' ')[0]}.csv';
  File file = File(fileName);
  await file.writeAsString(csvContent);

  await SharePlus.instance.share(
    ShareParams(subject: 'Attendance Report', files: [XFile(fileName)]),
  );
}
