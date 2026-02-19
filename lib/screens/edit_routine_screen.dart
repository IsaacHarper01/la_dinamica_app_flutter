import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class RoutineEditorPage extends StatefulWidget {
  final String initialRoutine;
  final String groupName;

  const RoutineEditorPage({
    super.key,
    required this.initialRoutine,
    required this.groupName,
  });

  @override
  State<RoutineEditorPage> createState() => _RoutineEditorPageState();
}

class _RoutineEditorPageState extends State<RoutineEditorPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialRoutine);
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    final logoBytes = await rootBundle.load('assets/images/f_ma18.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
        ),
        build: (context) => [
          _buildHeader(logoImage),
          pw.SizedBox(height: 20),
          _buildRoutineContent(_controller.text),
          pw.SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    Navigator.pop(context);
  }

  pw.Widget _buildHeader(pw.MemoryImage logo) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          height: 80,
          width: 80,
          child: pw.Image(logo),
        ),
        pw.SizedBox(width: 20),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "La Dinámica App",
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              "Rutina de Entrenamiento",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
            pw.Text(
              "Grupo: ${widget.groupName}",
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        )
      ],
    );
  }

  pw.Widget _buildRoutineContent(String text) {
    final lines = text.split('\n');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith("# ")) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(top: 12),
            child: pw.Text(
              line.replaceFirst("# ", ""),
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
        } else if (line.startsWith("## ")) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              line.replaceFirst("## ", ""),
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
        } else if (line.startsWith("- ")) {
          return pw.Bullet(
            text: line.replaceFirst("- ", ""),
            style: const pw.TextStyle(fontSize: 12),
          );
        } else {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(top: 4),
            child: pw.Text(
              line,
              style: const pw.TextStyle(fontSize: 12),
            ),
          );
        }
      }).toList(),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        "Documento generado profesionalmente para fines educativos.",
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Rutina"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Edita la rutina aquí...",
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
