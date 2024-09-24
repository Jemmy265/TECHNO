import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Features/Auth/widgets/custom_form_field.dart';
import 'package:think/Features/Auth/widgets/my_button.dart';
import 'package:think/Features/Profile/bloc/profile_bloc.dart';
import 'package:think/shared_prefs.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  static const String routeName = 'Profile';
  final formKey = GlobalKey<FormState>();
  String name = '';
  TextEditingController nameController = TextEditingController();
  File? file;
  bool haveFile = false;
  bool havePath = false;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    name = SharedPrefs.getName();
    nameController.text = name;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => ProfileBloc()..add(GetUserData()),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/background.png"))),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                )),
            body: Column(
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state.status == ProfileStatus.failed) {
                      return AlertDialog(
                        title: Text(state.errorMessage),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Try Again")),
                        ],
                      );
                    }
                    if (state.status == ProfileStatus.loadImage) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state.status == ProfileStatus.success ||
                        state.status == ProfileStatus.loading) {
                      if (state.imageFile != null) {
                        file = state.imageFile;
                        haveFile = true;
                      }
                      if (state.status == ProfileStatus.success) {
                        nameController.text = state.name;
                      }

                      if (state.path != '' && state.path != null) {
                        havePath = true;
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          haveFile
                              ? SizedBox(
                                  height: height * 0.2,
                                  child: Image.file(
                                    file!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : havePath
                                  ? CachedNetworkImage(
                                      imageUrl: state.path!,
                                      height: height * 0.20,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(Icons.error),
                                      ),
                                    )
                                  : SizedBox(
                                      height: height * 0.2,
                                    ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            height: height * 0.07,
                            width: width * 0.5,
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<ProfileBloc>()
                                    .add(GetLocalImage());
                              },
                              child: const MyButton(text: "Edit Photo"),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 25,
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                width: 1,
                                color: Color(0xff495D75),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Text(
                                      "Your Profile Data",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    SizedBox(
                                      height: height * 0.07,
                                    ),
                                    CustomFormField(
                                      hint: "your name",
                                      label: "Name",
                                      validator: (text) {
                                        if (text == null ||
                                            text.trim().isEmpty) {
                                          return "Please Enter Name";
                                        }
                                        return null;
                                      },
                                      controller: nameController,
                                    ),
                                    SizedBox(
                                      height: height * 0.1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state.status == ProfileStatus.failed) {
                      return AlertDialog(
                        title: Text(state.errorMessage),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Try Again")),
                        ],
                      );
                    }
                    if (state.status == ProfileStatus.loading) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state.status == ProfileStatus.success) {
                      SharedPrefs.setName(state.name);
                      return SizedBox(
                        width: width * 0.5,
                        child: InkWell(
                            onTap: () {
                              if (formKey.currentState?.validate() ?? false) {
                                if (file == null) {
                                  context.read<ProfileBloc>().add(
                                      UploadName(name: nameController.text));
                                } else {
                                  context.read<ProfileBloc>().add(
                                      UploadUserData(
                                          image: file!,
                                          name: nameController.text));
                                }
                              }
                            },
                            child: const MyButton(text: "Update")),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            )),
      ),
    );
  }
}
