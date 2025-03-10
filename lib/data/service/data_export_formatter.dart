import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExportHelper {
  // Extract Sales Data
  static List<List<String>> extractSalesData(
      List<QueryDocumentSnapshot> sales) {
    List<List<String>> data = [
      ["Date", "Sale ID", "Customer", "Amount"], // Header row
    ];

    for (var sale in sales) {
      Timestamp timestamp = sale['date'];
      DateTime date = timestamp.toDate();
      String formattedDate = "${date.day}-${date.month}-${date.year}";

      data.add([
        formattedDate,
        sale.id,
        sale['customerName'] ?? "Cash Sale",
        "₹${sale['totalAmount'].toStringAsFixed(2)}"
      ]);
    }

    return data;
  }

  // Extract Item Report Data
  static List<List<String>> extractItemData(
      Map<String, Map<String, dynamic>> itemReport) {
    List<List<String>> data = [
      ["Product", "Quantity Sold", "Revenue"],
    ];

    itemReport.forEach((product, details) {
      data.add([
        product,
        details['totalQty'].toString(),
        "₹${details['totalRevenue'].toStringAsFixed(2)}"
      ]);
    });

    return data;
  }

  // Extract Customer Ledger Data
  static List<List<String>> extractCustomerLedgerData(
      List<QueryDocumentSnapshot> ledger) {
    List<List<String>> data = [
      ["Date", "Sale ID", "Customer Name", "Amount"], // ✅ Table headers
    ];

    for (var entry in ledger) {
      //=Ensure 'date' exists before using it
      Timestamp? timestamp = entry['date'];
      DateTime date =
          timestamp?.toDate() ?? DateTime(2000, 1, 1); // Default fallback date
      String formattedDate = DateFormat("d MMM yyyy").format(date);

      String customerName = entry['customerName'] ?? "Cash Sale";
      String totalAmount = "₹${entry['totalAmount'].toStringAsFixed(2)}";

      data.add([
        formattedDate,
        entry.id,
        customerName,
        totalAmount,
      ]);
    }

    return data;
  }
}
