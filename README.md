# 📦 Inventory Management App

## 📌 Overview
The **Inventory Management App** is a Flutter-based system designed to efficiently manage products, customers, and sales transactions. It includes features like product listing, customer management, sales recording, and report generation with export options (PDF, Excel, Print, Email).

## ✨ Features
- 📋 **Product Management**: Add, edit, and delete products with stock tracking.
- 👤 **Customer Management**: Store customer details and maintain sales history.
- 🛒 **Sales Module**: Create new sales with customer selection (optional) and stock deduction.
- 📊 **Reports Section**:
  - **Sales Reports**: Track total revenue and transactions.
  - **Item Reports**: Monitor product sales.
  - **Customer Ledger**: View customer-specific transactions.
- 📂 **Export & Share**:
  - 📄 Export reports as **PDF & Excel**
  - 🖨 Print reports directly
  - 📧 Send reports via **Email**

## 🏗 Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Firestore
- **State Management**: Provider
- **Export Features**: pdf, excel, printing, and email plugins

## 🚀 Setup & Installation
### 1️⃣ Prerequisites
- Install [Flutter](https://flutter.dev/docs/get-started/install)
- Set up Firebase for Flutter ([Guide](https://firebase.flutter.dev/docs/installation/))

### 2️⃣ Clone the Repository
```bash
 git clone https://github.com/your-username/inventory-management-app.git
 cd inventory-management-app
```

### 3️⃣ Install Dependencies
```bash
 flutter pub get
```

### 4️⃣ Configure Firebase
- Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase Console.
- Enable Firestore Database in Firebase.

### 5️⃣ Run the App
```bash
 flutter run
```

## 📜 Project Structure
```
📂 lib/
 ├── 📂 common/           # Reusable widgets & UI components
 ├── 📂 data/
 │   ├── 📂 provider/     # State management (Provider)
 │   ├── 📂 service/      # Firebase interactions
 ├── 📂 view/
 │   ├── 📂 sales/        # Sales module
 │   ├── 📂 inventory/    # Product management
 │   ├── 📂 reports/      # Reports & export functionality
 │   ├── 📂 customer/     # Customer management
 ├── main.dart            # App entry point
```

## 🛠 Plugins Used
- `cloud_firestore` → Firebase Firestore
- `provider` → State Management
- `pdf` → PDF Generation
- `excel` → Export to Excel
- `printing` → Print functionality
- `flutter_email_sender` → Send reports via email

## 🤝 Contributing
1. **Fork** the repo.
2. Create a **feature branch**: `git checkout -b feature-branch`
3. **Commit** your changes: `git commit -m 'Add new feature'`
4. **Push** to the branch: `git push origin feature-branch`
5. Open a **Pull Request** 🚀



