import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelHelper {
  static Future<String> exportToExcel(String title, List<List<String>> data,
      {bool returnPath = false}) async {
    log("📂 Entered excel helper");
    log("📊 Data received: ${data.length} rows");

    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel[title];

      log("📝 Writing data to sheet...");

      // Convert List<String> into List<CellValue?>
      List<List<CellValue?>> convertedData = data.map((row) {
        log("🔹 Row: $row");
        return row.map((cell) => TextCellValue(cell)).toList();
      }).toList();

      for (var row in convertedData) {
        sheet.appendRow(row);
      }

      if (!(await Permission.storage.request().isGranted)) {
        log("❌ Storage permission denied!");
      }

      // 🔥 **Step 2: Get the Downloads Folder**
      Directory? directory = await getExternalStorageDirectory();
      String downloadsPath = "/storage/emulated/0/Download";

      if (directory != null && Platform.isAndroid) {
        downloadsPath = directory.path; // Ensure proper storage location
      }

      String filePath =
          '$downloadsPath/$title-${DateTime.now().millisecondsSinceEpoch}.xlsx';

      log("📂 Saving file to: $filePath");

      File file = File(filePath);
      file.createSync(recursive: true);

      final encodedExcel = excel.encode();
      if (encodedExcel == null) {
        log("❌ Excel encode() returned null!");
        return "";
      }

      file.writeAsBytesSync(encodedExcel);
      log("✅ File saved successfully!");

      if (returnPath) {
        return filePath;
      } else {
        log("📂 Opening file...");
        OpenFile.open(filePath).then((value) {
          log("✅ File opened successfully!");
        }).catchError((error) {
          log("❌ Error opening file: $error");
        });

        return "";
      }
    } catch (e) {
      log("❌ Error exporting Excel file: $e");
      return "";
    }
  }
}
