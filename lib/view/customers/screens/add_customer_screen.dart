import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/common/widgets/custom_button.dart';
import 'package:inventory_management_app/common/widgets/custom_text_form_field.dart';
import 'package:inventory_management_app/data/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phonenoController = TextEditingController();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(title: "Add Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                  controller: nameController,
                  hint: "Customer's Name",
                  label: "Customer's Name"),
              CustomTextFormField(
                  controller: addressController,
                  hint: "Address",
                  multiline: true,
                  label: "Address"),
              CustomTextFormField(
                controller: phonenoController,
                hint: "Phone no",
                label: "Phone no",
                number: true,
              ),
              customerProvider.isLoading
                  ? const CircularProgressIndicator(
                      color: mainColor,
                    )
                  : InkWell(
                      onTap: () {
                        customerProvider.addCustomer({
                          "name": nameController.text.trim(),
                          "address": addressController.text.trim(),
                          "phoneno": phonenoController.text.trim(),
                        }, context);
                      },
                      child: const CustomButton(text: 'ADD CUSTOMER'))
            ],
          ),
        ),
      ),
    );
  }
}
