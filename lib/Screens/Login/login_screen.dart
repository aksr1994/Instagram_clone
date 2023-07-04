import 'package:flutter/material.dart';
import 'package:insta_clone/Resources/auth_methods.dart';
import 'package:insta_clone/Responsive/mobile_screen.dart';
import 'package:insta_clone/Responsive/responsive_layout.dart';
import 'package:insta_clone/Responsive/web_screen_layout.dart';
import 'package:insta_clone/Screens/Home/home_screen.dart';
import 'package:insta_clone/Screens/SignUp/signup_screen.dart';
import 'package:insta_clone/Widgets/app_textfield.dart';
import 'package:insta_clone/utilities/utils.dart';
import 'package:insta_clone/Models/user_model.dart' as model;



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool _isLoading=false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUser()async{

    setState(() {
      _isLoading=true;
    });
    String result=await AuthenticationMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text
    );

    if(result=='success'){
      //showSnackBar(context, result);
      if(context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context)=>
                  const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout())));
      }
    }
    else{

      if(context.mounted) showSnackBar(context, result);
    }
    setState(() {
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 32
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
              AppTextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter e-mail",
                  textInputType: TextInputType.emailAddress
              ),
              const SizedBox(height: 24,),
              AppTextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter password",
                  textInputType: TextInputType.text,
                  isPass: true,
              ),
              const SizedBox(height: 24,),
              InkWell(
                onTap: (){
                  print('Login');
                  logInUser();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.lightBlue
                  ),
                  child: _isLoading
                      ?const Center(child: CircularProgressIndicator(
                              color:Colors.white ,
                            ))
                      :const Text('Log In'),
                ),
              ),
              const SizedBox(height: 12,),
              Flexible(child: Container(),flex: 2,),
              Container(
                padding: EdgeInsetsDirectional.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: (){
                        print('signup');
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen()));
                      },
                      child: Text(
                          'Sign Up',
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
