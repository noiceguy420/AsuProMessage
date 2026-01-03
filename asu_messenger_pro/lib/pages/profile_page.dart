import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersCollection = FirebaseFirestore.instance.collection('users');
  Future<void> editField(String attribute) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) =>Padding(
          padding: EdgeInsets.all(10),
          child:  AlertDialog(
            title: Text(
              'Edit $attribute',
            ),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Enter new $attribute',),
              onChanged: (value) {
                newValue = value;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                  )
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(newValue);
                  },
                  child: const Text(
                    'Save',
                  ))
            ],
          )
      ) ,
    );
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.uid).update({attribute: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  SingleChildScrollView(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 280,
                          width: double.infinity,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(
                              16.0, 240.0, 16.0, 16.0),
                          child: Column(
                            children: [
                              Stack(children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  margin: const EdgeInsets.only(top: 16.0),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 110.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userData['username'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  Text(userData['email'],
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  const SizedBox(
                                                    height: 40,
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              CircleAvatar(
                                                child: IconButton(
                                                    onPressed: () {
                                                      editField("username");
                                                    },
                                                    icon: Icon(
                                                      Icons.edit_outlined,
                                                      size: 18,
                                                    )),
                                              )
                                            ],
                                          )),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: (){
                                                          editField('Age');
                                                        },
                                                        icon: Icon(Icons.edit))
                                                  ],
                                                ),
                                                Text(
                                                  "Age",
                                                  style:
                                                  TextStyle(fontSize: 18),
                                                ),
                                                Divider(
                                                  thickness: 2,
                                                ),
                                                Text(userData['Age'],
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: (){
                                                          editField('GPA');
                                                        },
                                                        icon: Icon(Icons.edit))
                                                  ],
                                                ),
                                                Text("GPA",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Divider(
                                                  thickness: 2,
                                                ),
                                                Text(userData['GPA'],
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: (){
                                                          editField('HoursPassed');
                                                        },
                                                        icon: Icon(Icons.edit))
                                                  ],
                                                ),
                                                Text("Hours Passed",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Divider(
                                                  thickness: 2,
                                                ),
                                                Text(userData['Hours'],
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),),
                                  margin: const EdgeInsets.only(left: 20.0),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('error'),
              );
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}