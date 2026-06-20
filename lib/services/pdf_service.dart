import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/lead.dart';

class PdfService {
  static Future<void> generateAndDownload({
    required String businessName,
    required List<Lead> leads,
    required List<Map<String, String>> competitors,
    required String positioning,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.indigo700,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Smart Marketing Report',
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('Business: $businessName',
                    style: pw.TextStyle(
                        color: PdfColors.white, fontSize: 14)),
                pw.Text(
                    'Generated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: pw.TextStyle(
                        color: PdfColors.white, fontSize: 12)),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Competitor Analysis
          if (competitors.isNotEmpty) ...[
            pw.Text('Competitor Analysis',
                style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.indigo700)),
            pw.SizedBox(height: 8),
            ...competitors.asMap().entries.map((entry) {
              final index = entry.key;
              final competitor = entry.value;
              final ranks = ['#1', '#2', '#3'];
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.indigo50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${ranks[index]} ${competitor['name']}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14)),
                    pw.SizedBox(height: 4),
                    pw.Text('Weakness: ${competitor['weakness']}',
                        style: const pw.TextStyle(
                            color: PdfColors.orange700, fontSize: 12)),
                    pw.Text('Your Edge: ${competitor['positioning']}',
                        style: const pw.TextStyle(
                            color: PdfColors.green700, fontSize: 12)),
                  ],
                ),
              );
            }),
            if (positioning.isNotEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.indigo100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text('Strategy: $positioning',
                    style: pw.TextStyle(
                        color: PdfColors.indigo700,
                        fontStyle: pw.FontStyle.italic,
                        fontSize: 12)),
              ),
            pw.SizedBox(height: 20),
          ],

          // Leads
          pw.Text('Generated Leads',
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.indigo700)),
          pw.SizedBox(height: 8),

          ...leads.map((lead) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 16),
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.indigo200),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(lead.businessName,
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.indigo700)),
                pw.Divider(color: PdfColors.indigo200),
                pw.Text('Generated Email',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.indigo700,
                        fontSize: 12)),
                pw.SizedBox(height: 4),
                pw.Text(lead.generatedEmail,
                    style: const pw.TextStyle(fontSize: 11)),
                pw.SizedBox(height: 8),
                pw.Text('Portfolio Pitch',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.indigo700,
                        fontSize: 12)),
                pw.SizedBox(height: 4),
                pw.Text(lead.portfolioPitch,
                    style: const pw.TextStyle(fontSize: 11)),
              ],
            ),
          )),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'smart_marketing_$businessName.pdf',
    );
  }
}