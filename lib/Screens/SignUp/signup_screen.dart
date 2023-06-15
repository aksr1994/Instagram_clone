import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/Resources/auth_methods.dart';
import 'package:insta_clone/Responsive/mobile_screen.dart';
import 'package:insta_clone/Responsive/responsive_layout.dart';
import 'package:insta_clone/Responsive/web_screen_layout.dart';
import 'package:insta_clone/Widgets/app_textfield.dart';
import 'package:insta_clone/utilities/utils.dart';
import 'package:insta_clone/Models/user_model.dart' as model;



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
  bool _isLoading=false;

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

  void signUpUser () async{
    setState(() {
      _isLoading=true;
    });
    print('SignUp Initiated');
    String result=await AuthenticationMethods().signUpUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        file: Uint8List.fromList('https://images5.alphacoders.com/447/447126.jpg'.codeUnits));

    print('Result: $result');
    if(result=='success'){
      setState(() {
        _isLoading=false;
      });
      print('Navigation');
      if(context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context)=> const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout())));
      }

    }
    else {
      print('Result not success');
      setState(() {
        _isLoading=false;
      });
      if(context.mounted) showSnackBar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
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

              //Circular Avatar Stack
              Stack(
                children: [
                  _image!=null
                      ?CircleAvatar(
                      radius: 64,
                      backgroundImage:MemoryImage(_image!)
                      )
                      :const CircleAvatar(
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
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.lightBlue
                  ),
                  child: _isLoading
                      ?const Center(
                        child:CircularProgressIndicator(
                          color: Colors.white,
                        ) ,
                      )
                      :const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 12,),
              Flexible(child: Container(),flex: 2,),
              Container(
                padding: EdgeInsetsDirectional.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: (){
                        print('log in');
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            fontWeight:FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
