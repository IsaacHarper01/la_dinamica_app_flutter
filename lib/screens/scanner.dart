import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> scannerQR(BuildContext context) async {
  // Request camera permission
  var status = await Permission.camera.request();
  final logger = Logger();

  if (!status.isGranted) return;

  if (!context.mounted) return;

  // Navigate to the scanner screen and wait for the result
  final String? scannedCode = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ScannerScreen()),
  );


  // If the user didn't scan anything, return without doing anything.
  if (scannedCode == null) {
    logger.d('No se escaneó ningún código QR o el código QR es inválido.');
    return;
  };

  try {
    List<String>? data = scannedCode.split(',');

    if (data.length < 5) {
      logger.e("Formato de datos incorrecto: $scannedCode");
      Navigator.pop(context, null);
      return;
    }

    int id = int.tryParse(data[0]) ?? -1;
    if (id == -1) {
      logger.e("ID no válido: $data[0]");
      Navigator.pop(context, null);
      return;
    }

    String name = data[1];
    String address = data[2];
    String phone = data[3];
    String age = data[4];

    final db = DatabaseHelper();
    db.InserAttendanceData(id, name);
    db.varifyPay(id);

    logger.i('Datos del QR procesados correctamente.');
    logger.i('Registrado correctamente');

    Navigator.pop(context, scannedCode);
  } catch (e) {
    logger.e('Error al procesar los datos del QR: $e');
    Navigator.pop(context, scannedCode);
  }
}

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear QR")),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: (BarcodeCapture barcode) {
          if (barcode.raw == null) {
            Navigator.pop(context, null);
            return;
          }

          final String scannedData = barcode.raw!.toString();

          if (!scannedData.contains(',')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('El código QR no es válido.'))
            );
            Navigator.pop(context, null);
            return;
          }

          Navigator.pop(context, scannedData);
        },
      ),
    );
  }
}
