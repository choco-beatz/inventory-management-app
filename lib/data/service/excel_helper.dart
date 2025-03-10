import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';

class ExcelHelper {
 static Future<String> exportToExcel(String title, List<List<String>> data, {bool returnPath = false}) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel[title];

  List<List<CellValue?>> convertedData = data.map((row) {
    return row.map((cell) => TextCellValue(cell)).toList();
  }).toList();

  for (var row in convertedData) {
    sheet.appendRow(row);
  }

  final directory = await getTemporaryDirectory();
  String filePath = '${directory.path}/$title-${DateTime.now().millisecondsSinceEpoch}.xlsx';
  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.encode()!);

  if (returnPath) {
    return filePath;
  } else {
    OpenFile.open(filePath);
    return "";
  }
}

}
