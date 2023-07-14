import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Resources/auth_methods.dart';
import 'package:insta_clone/Resources/firestore_methods.dart';
import 'package:insta_clone/Screens/Login/login_screen.dart';
import 'package:insta_clone/utilities/colors.dart';
import 'package:insta_clone/utilities/utils.dart';

import '../../Widgets/app_follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  String uid=FirebaseAuth.instance.currentUser!.uid;
  var userData = null;
  int postLength = 0;
  int followerCount = 0;
  int followingCount = 0;
  bool isFollowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //getting post length
      var postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postSnapshot.docs.length;

      userData = userSnapshot.data()!;
      followerCount = userSnapshot['followers'].length;
      followingCount = userSnapshot['following'].length;

      isFollowing = userSnapshot['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      print('Fetching profile error: $e');
      showSnackBar(context, e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('UID: ${widget.uid}');
    print('username: ${FirebaseAuth.instance.currentUser!.uid}');
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 40,
                            backgroundImage: NetworkImage(userData['photoURL']),
                          ),
                          _profileStats(context),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(userData['bio']),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            DocumentSnapshot postGridSnapshot =
                                (snapshot.data as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image:
                                    NetworkImage(postGridSnapshot['postURL']),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    })
              ],
            ));
  }

  //Posts,follower,followers and edit button
  Widget _profileStats(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn(postLength, 'Posts'),
              _buildStatColumn(followerCount, 'Followers'),
              _buildStatColumn(followingCount, 'Following')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FirebaseAuth.instance.currentUser!.uid == widget.uid
                  ? AppFollowButton(
                      onPressed: () async {
                        print('follow');
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Are you sure?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        await AuthenticationMethods()
                                            .signOutUser();
                                        if (mounted) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen()));
                                        }
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'))
                                ],
                              );
                            });
                      },
                      text: 'Sign Out',
                      backgroundColor: mobileBackgroundColor,
                      textColor: primaryColor,
                      borderColor: Colors.grey,
                    )
                  : isFollowing
                      ? AppFollowButton(
                          onPressed: () async {
                            print('Unfollow');
                            await FireStoreMethods().followUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                userData['uid']);
                            setState(() {
                              isFollowing = false;
                              followerCount--;
                            });
                          },
                          text: 'Unfollow',
                          backgroundColor: mobileBackgroundColor,
                          textColor: primaryColor,
                          borderColor: Colors.grey,
                        )
                      : AppFollowButton(
                          onPressed: () async {
                            print('Follow');
                            await FireStoreMethods().followUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                userData['uid']);
                            setState(() {
                              isFollowing = true;
                              followerCount++;
                            });
                          },
                          text: 'Follow',
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          borderColor: Colors.blue,
                        )
            ],
          )
        ],
      ),
    );
  }

  Column _buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
