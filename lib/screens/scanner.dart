import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Barcode?> scannerQR(BuildContext context) async {
  // Request camera permission
  var status = await Permission.camera.request();
  final logger = Logger();

  if (!status.isGranted) return null;
  if (!context.mounted) return null;

  // Navigate to the scanner screen and wait for the result
  final Barcode? scannedCode = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ScannerScreen()),
  );

  if (scannedCode == null) {
    logger.d('No se escaneó ningún código o el código es inválido.');
    return null;
  }
  if (scannedCode.rawValue == null) {
    logger.d('No se escaneó ningún código o el código es inválido.');
    return null;
  }
  else{
    return Future.value(scannedCode);
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
      appBar: AppBar(title: const Text("Escanear")),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: (BarcodeCapture barcode) async {
          if (barcode.barcodes.isEmpty ||
              barcode.barcodes.first.rawValue == null) {
            Navigator.pop(context, null);
            return;
          }

          final Barcode? scannedData = barcode.barcodes.first;

          _scannerController.stop();
          await Future.delayed(const Duration(milliseconds: 300));
          Navigator.pop(context, scannedData);
        },
      ),
    );
  }
}
