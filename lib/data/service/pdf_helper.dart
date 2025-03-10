import 'dart:io';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfHelper {
  static Future<void> printReport(String title, List<List<String>> data) async {
    final pdf = pw.Document();

    //Generate the PDF for printing
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy');
    final dateString = formatter.format(now);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(title, dateString),
        footer: (context) =>
            _buildFooter(context.pageNumber, context.pagesCount),
        build: (context) => [
          _buildTable(data),
          pw.SizedBox(height: 20),
          _buildSummary(data),
        ],
      ),
    );

    //Open the print dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static Future<String> generateSalesPdf(String title, List<List<String>> data, {bool returnPath = false}) async {
  final pdf = pw.Document();
  final now = DateTime.now();
  final formatter = DateFormat('dd-MM-yyyy');
  final dateString = formatter.format(now);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (context) => _buildHeader(title, dateString),
      footer: (context) => _buildFooter(context.pageNumber, context.pagesCount),
      build: (context) => [
        _buildTable(data),
        pw.SizedBox(height: 20),
        _buildSummary(data),
      ],
    ),
  );

  final output = await getTemporaryDirectory();
  String filePath = '${output.path}/$title-${DateTime.now().millisecondsSinceEpoch}.pdf';
  File file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  if (returnPath) {
    return filePath;
  } else {
    OpenFile.open(filePath);
    return "";
  }
}

  static pw.Widget _buildHeader(String title, String dateString) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 24,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generated on: $dateString',
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.grey700,
            ),
          ),
          pw.Divider(thickness: 1),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(int currentPage, int totalPages) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Inventory Management System',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Text(
            'Page $currentPage of $totalPages',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTable(List<List<String>> data) {
    // Extract headers (first row)
    final headers = data.isNotEmpty ? data[0] : [];
    // Extract data rows (all except first)
    final List<List<String>> rows = data.length > 1 ? data.sublist(1) : [];

    return pw.TableHelper.fromTextArray(
      headerStyle: const pw.TextStyle(
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.blue900,
      ),
      headerHeight: 40,
      cellHeight: 35,
      cellAlignment: pw.Alignment.centerLeft,
      headers: headers,
      data: rows,
      border: pw.TableBorder.all(
        color: PdfColors.grey300,
        width: 0.5,
      ),
    );
  }

  static pw.Widget _buildSummary(List<List<String>> data) {
    if (data.isEmpty || data.length <= 1) {
      return pw.Container();
    }

    // Determine which column contains amount data (usually the last column)
    final amountIndex = data[0].length - 1;
    double totalAmount = 0;

    // Calculate totals
    for (int i = 1; i < data.length; i++) {
      final row = data[i];
      if (row.length > amountIndex) {
        String amountStr = row[amountIndex].replaceAll('₹', '').trim();
        try {
          double amount = double.parse(amountStr);
          totalAmount += amount;
        } catch (e) {
          // Skip if can't parse
        }
      }
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: const pw.TextStyle(
              fontSize: 16,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Items: ${data.length - 1}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
                style: const pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.blue900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Extra method for generating customer-specific reports
  static Future<void> generateCustomerReport(
      String customerName, List<List<String>> data) async {
    await generateSalesPdf('Customer Report - $customerName', data);
  }

  // Method for generating inventory reports
  static Future<void> generateInventoryReport(List<List<String>> data) async {
    await generateSalesPdf('Inventory Status Report', data);
  }
}
