import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/Providers/user_provider.dart';
import 'package:insta_clone/Resources/firestore_methods.dart';
import 'package:insta_clone/utilities/colors.dart';
import 'package:insta_clone/utilities/utils.dart';
import 'package:provider/provider.dart';

import '../../Models/user_model.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  Uint8List? _file;
  final TextEditingController _descriptionController=TextEditingController();
  bool _isLoading=false;


  _loadProfilePic(User user){
  }


  _selectImage(BuildContext context)async{
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Create a post'),
        children: [
          //Camera
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a Photo'),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file=await pickImage(ImageSource.camera);
              setState(() {
                _file=file;
              });
              
            },
          ),

          //Gallery
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from Gallery'),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file=await pickImage(ImageSource.gallery);
              setState(() {
                _file=file;
              });

            },
          ),

          //Cancel
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }

  Future<void> postImage(
      String uid,
      String username,
      String profImage) async {
    setState(() {
      _isLoading=true;
    });

    try{
      String result=await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage);

      if(result=='success'){
        setState(() {
          _isLoading=false;
        });
        if(mounted) showSnackBar(context, 'Post Successful');
        clearImage();
      }
      else{
        setState(() {
          _isLoading=false;
        });
        if(mounted) showSnackBar(context, result);
      }


    }catch(e){
      showSnackBar(context, e.toString());
      print('Post Error: ${e.toString()}');
    }
  }

  void clearImage(){
    setState(() {
      _file=null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    final User? user=userProvider.getUser;
    print('Image: ${user?.photoURL}');
    _loadProfilePic(user!);

    return _file==null
        ?Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: ()=>_selectImage(context)
      ),
    )
    :Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: ()=>clearImage(),
        ),
        title: const Text('New Post'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: ()=> postImage(user.uid, user.username, user.photoURL),
              child: const Text(
                'Post',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),))
        ],
      ),
      //body: addPostBody(context, user!)
      body: addPostBody(context, user),
    );
  }

  Widget addPostBody(BuildContext context,User user){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _isLoading
              ?const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              )
              :const Padding(padding: EdgeInsets.only(top: 0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.4,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a Caption',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        // image: NetworkImage(
                        //   'https://img.freepik.com/free-vector/blur-pink-blue-abstract-gradient-background-vector_53876-174836.jpg',
                        // ),
                        image: MemoryImage(_file!)
                      )
                    ),
                  ),
                ),
              ),
              const Divider()

            ],
          )
        ],
      ),
    );
  }
}
