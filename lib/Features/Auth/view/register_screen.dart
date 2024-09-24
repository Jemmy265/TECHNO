import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';
import 'package:think/Features/Auth/bloc/firebase_bloc.dart';
import 'package:think/Features/Auth/bloc/firebase_event.dart';
import 'package:think/Features/Auth/bloc/firebase_state.dart';
import 'package:think/Features/Auth/view/login_screen.dart';
import 'package:think/Features/Auth/widgets/custom_form_field.dart';
import 'package:think/Features/Auth/widgets/my_button.dart';
import 'package:think/Features/Auth/widgets/welcome_widget.dart';
import 'package:think/Features/Home/home_screen.dart';
import 'package:think/shared_prefs.dart';
import 'package:think/Core/utility/validation.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "register";
  final formKey = GlobalKey<FormState>();
  final FirebaseManager firebaseManager = FirebaseManager();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return BlocProvider(
      create: (context) => FirebaseBloc(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/background.png"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocListener<FirebaseBloc, FirebaseState>(
            listener: (context, state) {
              if (state.status == FirebaseStatus.successSignUp) {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              } else if (state.status == FirebaseStatus.failed) {
                showDialog(
                    context: context,
                    builder: (ctx) => Center(
                          child: AlertDialog(
                            content: Text(state.errorMessage),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Try Again"))
                            ],
                          ),
                        ),
                    barrierDismissible: true);
              }
            },
            child: SafeArea(
              child: Column(
                children: [
                  WelcomeWidget(height: height),
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 25,
                    ),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(
                            width: 1, color: Color(0xff495D75))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text("Register",
                              style: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomFormField(
                                  controller: nameController,
                                  hint: "your Name",
                                  label: "Name",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return "Please Enter Name";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                CustomFormField(
                                  controller: emailController,
                                  label: "Email Address",
                                  hint: "yourname@email.com",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return "Please Enter Email";
                                    }
                                    if (!ValidationUtils.isValidEmail(text)) {
                                      return "Email not valid";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                CustomFormField(
                                  controller: passwordController,
                                  hint: "your password",
                                  label: "Password",
                                  keyboardType: TextInputType.text,
                                  isPassword: true,
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return "Please Enter Password";
                                    }
                                    if (text.length < 6) {
                                      return "Password should be at least 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                BlocBuilder<FirebaseBloc, FirebaseState>(
                                  builder: (context, state) {
                                    if (state.status ==
                                        FirebaseStatus.loading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return InkWell(
                                      onTap: () async {
                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          context
                                              .read<FirebaseBloc>()
                                              .add(SignUpTry(
                                                name: nameController.text,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              ));
                                          await SharedPrefs.setEmail(
                                              emailController.text);
                                          await SharedPrefs.setPassword(
                                              passwordController.text);
                                          await SharedPrefs.setName(
                                              nameController.text);
                                        }
                                      },
                                      child: const MyButton(text: "Register"),
                                    );
                                    // ElevatedButton(
                                    //   onPressed: () async {
                                    //     if (formKey.currentState?.validate() ??
                                    //         false) {
                                    //       context
                                    //           .read<FirebaseBloc>()
                                    //           .add(SignUpTry(
                                    //             name: nameController.text,
                                    //             email: emailController.text,
                                    //             password:
                                    //                 passwordController.text,
                                    //           ));
                                    //       await SharedPrefs.setEmail(
                                    //           emailController.text);
                                    //       await SharedPrefs.setPassword(
                                    //           passwordController.text);
                                    //       await SharedPrefs.setName(
                                    //           nameController.text);
                                    //     }
                                    //   },
                                    //   style: ElevatedButton.styleFrom(
                                    //     padding: const EdgeInsets.symmetric(
                                    //         vertical: 12),
                                    //     backgroundColor: Colors.blueAccent,
                                    //   ),
                                    //   child: const Text(
                                    //     "Register",
                                    //     style: TextStyle(
                                    //         fontSize: 24, color: Colors.white),
                                    //   ),
                                    // );
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pushReplacementNamed(
                                            context, LoginScreen.routeName),
                                    child: const Text(
                                      "Already have account ?",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
