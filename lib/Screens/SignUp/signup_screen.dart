import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/Resources/auth_methods.dart';
import 'package:insta_clone/Widgets/app_textfield.dart';
import 'package:insta_clone/utilities/utils.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  final TextEditingController _usernameController=TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage()async{
    print('Open Image Picker');
    Uint8List img= await pickImage(ImageSource.gallery);
    setState(() {
      _image=img;
    });
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              Image.asset(
                'assets/ig_logo.png',
                color: Colors.blue,
                height: 64,
              ),

              const SizedBox(height: 64,),
              //Circulat Avatar Stack
              Stack(
                children: [
                  _image!=null
                      ?CircleAvatar(
                      radius: 64,
                      backgroundImage:MemoryImage(_image!)
                      )
                      :CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage('https://img.freepik.com/free-photo/puppy-that-is-walking-snow_1340-37228.jpg?w=2000')
                      ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: (){
                        selectImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24,),

              //Username
              AppTextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter Username",
                  textInputType: TextInputType.text
              ),
              const SizedBox(height: 24,),

              //E-mail
              AppTextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter e-mail",
                  textInputType: TextInputType.emailAddress
              ),
              const SizedBox(height: 24,),

              //Password
              AppTextFieldInput(
                textEditingController: _passwordController,
                hintText: "Enter Password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 24,),

              //Bio
              AppTextFieldInput(
                  textEditingController: _bioController,
                  hintText: "Enter Bio",
                  textInputType: TextInputType.text
              ),
              const SizedBox(height: 24,),

              //SignUP Button
              InkWell(
                onTap: ()async{
                  print('SignUp Initiated');
                  String result=await AuthenticationMethods().signUpUser(
                      username: _usernameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      bio: _bioController.text,
                      file: Uint8List.fromList('https://images5.alphacoders.com/447/447126.jpg'.codeUnits));
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.lightBlue
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 12,),
              Flexible(child: Container(),flex: 2,),
              // Container(
              //   padding: EdgeInsetsDirectional.symmetric(vertical: 12),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text("Don't have an account?"),
              //       GestureDetector(
              //         onTap: (){
              //           print('signup');
              //         },
              //         child: Text(
              //           'Sign Up',
              //           style: TextStyle(
              //               fontWeight:FontWeight.bold
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )

            ],
          ),
        ),
      ),
    );
  }
}
