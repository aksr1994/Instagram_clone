import 'package:flutter/material.dart';
import 'package:insta_clone/Providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../utilities/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({super.key, required this.webScreenLayout, required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData()async{
   UserProvider _userProvider= Provider.of(context,listen: false);
   await _userProvider.refreshUser();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        if(constraints.maxWidth>webScreenSize){
          //webscreen
          return widget.webScreenLayout;
        }
        else
          {
            //mobilescreen

            return widget.mobileScreenLayout;
          }
      },
    );
  }
}
