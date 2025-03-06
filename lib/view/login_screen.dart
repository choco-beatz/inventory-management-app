import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';
import 'package:inventory_management_app/common/space.dart';
import 'package:inventory_management_app/common/text.dart';

import 'package:inventory_management_app/common/widgets/custom_appbar.dart';
import 'package:inventory_management_app/common/widgets/custom_button.dart';
import 'package:inventory_management_app/common/widgets/custom_text_form_field.dart';
import 'package:inventory_management_app/data/provider/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            title: "Login",
          )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text30(
                text: "Welcome",
              ),
              space,
              CustomTextFormField(
                controller: emailController,
                hint: 'Email',
                label: 'Email',
              ),
             
              CustomTextFormField(
                controller: passwordController,
                hint: 'Password',
                label: 'Password',
              ),
              
              if (loginProvider.errorMessage.isNotEmpty)
                Text(loginProvider.errorMessage),
              space,
              loginProvider.isLoading
                  ? const CircularProgressIndicator(
                      color: mainColor,
                    )
                  : InkWell(
                      onTap: () {
                        loginProvider.login(
                            emailController.text, passwordController.text);
                      },
                      child: const CustomButton(text: 'Login'))
            ],
          ),
        ),
      ),
    );
  }
}
