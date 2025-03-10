import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/common/widgets/custom_button.dart';
import 'package:inventory_management_app/common/widgets/custom_text_form_field.dart';
import 'package:inventory_management_app/data/provider/product_provider.dart';
import 'package:provider/provider.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController stockController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(title: "Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                label: "Price",
                number: true,
              ),
              productProvider.isLoading
                  ? const CircularProgressIndicator(
                      color: mainColor,
                    )
                  : InkWell(
                      onTap: () {
                        productProvider.addProduct({
                          "name": nameController.text.trim(),
                          "description": descriptionController.text.trim(),
                          "stock": stockController.text.trim(),
                          "price": priceController.text.trim(),
                          "id": DateTime.now().millisecond,
                        }, context);
                      },
                      child: const CustomButton(text: 'ADD PRODUCT'))
            ],
          ),
        ),
      ),
    );
  }
}
