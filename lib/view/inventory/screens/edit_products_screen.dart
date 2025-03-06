import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/common/widgets/custom_button.dart';
import 'package:inventory_management_app/common/widgets/custom_text_form_field.dart';
import 'package:inventory_management_app/data/provider/product_provider.dart';
import 'package:provider/provider.dart';

class EditProducts extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String stock;
  final String price;
  const EditProducts(
      {super.key,
      required this.id,
      required this.name,
      required this.description,
      required this.stock,
      required this.price});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;
  late TextEditingController priceController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    stockController = TextEditingController(text: widget.stock);
    priceController = TextEditingController(text: widget.price);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(title: "Edit Product"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(children: [
              CustomTextFormField(
                  controller: nameController,
                  hint: "Product's Name",
                  label: "Product's Name"),
              CustomTextFormField(
                  controller: descriptionController,
                  hint: "Description",
                  multiline: true,
                  label: "Description"),
              CustomTextFormField(
                controller: stockController,
                hint: "Stock",
                label: "Stock",
                number: true,
              ),
              CustomTextFormField(
                controller: priceController,
                hint: "Price",
                label: "Product's Name",
                number: true,
              ),
              productProvider.isLoading
                  ? const CircularProgressIndicator(
                      color: mainColor,
                    )
                  : InkWell(
                      onTap: () {
                        productProvider.updateProduct(
                          widget.id,
                          {
                            "name": nameController.text.trim(),
                            "description": descriptionController.text.trim(),
                            "stock": stockController.text.trim(),
                            "price": priceController.text.trim()
                          },
                          context,
                        );
                      },
                      child: const CustomButton(text: 'UPDATE PRODUCT'))
            ]))));
  }
}
