import 'package:flutter/material.dart';
import 'package:insta_clone/Screens/SignUp/signup_screen.dart';
import 'package:insta_clone/Widgets/app_textfield.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsetsDirectional.symmetric(
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
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.lightBlue
                  ),
                  child: const Text('Log In'),
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
