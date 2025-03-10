import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/space.dart';
import 'package:inventory_management_app/common/text.dart';
import 'package:inventory_management_app/data/service/data_export_formatter.dart';
import 'package:inventory_management_app/data/service/email_helper.dart';
import 'package:inventory_management_app/data/service/excel_helper.dart';
import 'package:inventory_management_app/data/service/pdf_helper.dart';

void showExportOptions(BuildContext context, String reportType, dynamic data) {
  showModalBottomSheet(
    backgroundColor: mainColor,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextW22(text: "Export $reportType"),
            space,
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: white),
              title: const TextW16(text: "Export as PDF"),
              onTap: () {
                List<List<String>> extractedData;
                String title;

                switch (reportType) {
                  case "Sales Report":
                    extractedData = ExportHelper.extractSalesData(data);
                    title = "Sales Report";
                    break;
                  case "Items Report":
                    extractedData = ExportHelper.extractItemData(data);
                    title = "Item Report";
                    break;
                  case "Customer Ledger":
                    extractedData =
                        ExportHelper.extractCustomerLedgerData(data);
                    title = "Customer Ledger";
                    break;
                  default:
                    return;
                }

                PdfHelper.generateSalesPdf(title, extractedData);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: white),
              title: const TextW16(text: "Export as Excel"),
              onTap: () async {
                List<List<String>> extractedData;
                String title;

                switch (reportType) {
                  case "Sales Report":
                    extractedData = ExportHelper.extractSalesData(data);
                    title = "Sales Report";
                    break;
                  case "Items Report":
                    extractedData = ExportHelper.extractItemData(data);
                    title = "Item Report";
                    break;
                  case "Customer Ledger":
                    extractedData =
                        ExportHelper.extractCustomerLedgerData(data);
                    title = "Customer Ledger";
                    break;
                  default:
                    return;
                }

                //Call function to generate Excel file
                await ExcelHelper.exportToExcel(title, extractedData);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: white),
              title: const TextW16(text: "Print Report"),
              onTap: () async {
                List<List<String>> extractedData;
                String title;

                switch (reportType) {
                  case "Sales Report":
                    extractedData = ExportHelper.extractSalesData(data);
                    title = "Sales Report";
                    break;
                  case "Items Report":
                    extractedData = ExportHelper.extractItemData(data);
                    title = "Item Report";
                    break;
                  case "Customer Ledger":
                    extractedData =
                        ExportHelper.extractCustomerLedgerData(data);
                    title = "Customer Ledger";
                    break;
                  default:
                    return;
                }

                //Call print function instead of generating a file
                PdfHelper.printReport(title, extractedData);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: white),
              title: const TextW16(text: "Send via Email"),
              onTap: () async {
                List<List<String>> extractedData;
                String title;
                String filePath;

                switch (reportType) {
                  case "Sales Report":
                    extractedData = ExportHelper.extractSalesData(data);
                    title = "Sales Report";
                    filePath = await PdfHelper.generateSalesPdf(
                        title, extractedData,
                        returnPath: true);
                    break;
                  case "Items Report":
                    extractedData = ExportHelper.extractItemData(data);
                    title = "Item Report";
                    filePath = await ExcelHelper.exportToExcel(
                        title, extractedData,
                        returnPath: true);
                    break;
                  case "Customer Ledger":
                    extractedData =
                        ExportHelper.extractCustomerLedgerData(data);
                    title = "Customer Ledger";
                    filePath = await PdfHelper.generateSalesPdf(
                        title, extractedData,
                        returnPath: true);
                    break;
                  default:
                    return;
                }

                // ✅ Call function to send email
                await EmailHelper.sendEmailWithAttachment(title, filePath);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
