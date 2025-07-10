import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:la_dinamica_app/models/User.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Map<String, dynamic>?> scannerQR(BuildContext context, String tenantId) async {
  // Request camera permission
  var status = await Permission.camera.request();
  final logger = Logger();

  if (!status.isGranted) return null;
  if (!context.mounted) return null;

  // Navigate to the scanner screen and wait for the result
  final String? scannedCode = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ScannerScreen()),
  );

  if (scannedCode == null) {
    logger.d('No se escaneó ningún código QR o el código QR es inválido.');
    return null;

  }

  try {
    Map<String, dynamic> info = jsonDecode(scannedCode);
    final awsDb = DataStoreReadService();

    if (info['action']=='attendance'){
        int id = info['id'] ?? -1;

        if (id == -1) {
          logger.e("ID no válido: ${info['id']}");
          return null;
        }

        String name = info['name'];
        
        
        if (await awsDb.checkIfStudentExists(id, tenantId)) {
          //check if student exist in General table
          logger.i('Asistencia de $name registrada con ID: $id');
          return Future.value({'action':'attendance','id': id, 'name': name});
        } else {
          logger.i('Alumno no encontrado');
          return null;
        }
      }
    else if(info['action']=='profesor'){
       String tenantId = info['db_id'];
       return Future.value({'action':'profesor','tenantId':tenantId});
    }
    else{
      return null;
    }
  } catch (e) {
    logger.e('Error al procesar los datos del QR: $e');
    return null;
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
        onDetect: (BarcodeCapture barcode) async {
          if (barcode.barcodes.isEmpty ||
              barcode.barcodes.first.rawValue == null) {
            Navigator.pop(context, null);
            return;
          }

          final String? scannedData = barcode.barcodes.first.rawValue;

          _scannerController.stop();
          await Future.delayed(const Duration(milliseconds: 300));
          Navigator.pop(context, scannedData);
        },
      ),
    );
  }
}
