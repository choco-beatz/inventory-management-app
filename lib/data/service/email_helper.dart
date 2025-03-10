
import 'dart:developer';

import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailHelper {
  static Future<void> sendEmailWithAttachment(String title, String filePath) async {
    final Email email = Email(
      subject: title,
      body: "Please find the attached $title report.",
      recipients: [], //Add recipient emails if needed
      attachmentPaths: [filePath], //Attach the file
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      log("✅ Email sent successfully!");
    } catch (e) {
      log("❌ Error sending email: $e");
    }
  }
}
