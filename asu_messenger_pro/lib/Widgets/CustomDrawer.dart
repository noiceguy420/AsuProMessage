import 'package:asu_messenger_pro/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/profile_page.dart';
import '../pages/users_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  static ValueNotifier<bool> darkMode = ValueNotifier(true);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: CustomDrawer.darkMode,
      builder: (context, darkMode, child) {
        return Drawer(
            backgroundColor: darkMode ? Colors.black87 : Colors.white,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    return ListView(
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userData['username'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text(userData['email'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.group, size: 30),
                          title: Text('Users', style: TextStyle(fontSize: 25)),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => UsersPage()));
                          },
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.person, size: 30),
                          title: Text('Profile', style: TextStyle(fontSize: 25)),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()));
                          },
                        ),
                        SizedBox(height: 40),
                        ListTile(
                          leading: Icon(Icons.logout, size: 30),
                          title: Text('Logout', style: TextStyle(fontSize: 25)),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage()));
                          },
                        ),
                        SizedBox(height: 40),
                        ListTile(
                          leading: Icon(
                            darkMode
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            size: 30,
                          ),
                          title: Text(
                            darkMode ? 'enable light mode' : 'enable dark mode',
                            style: TextStyle(fontSize: 25),
                          ),
                          onTap: () {
                            CustomDrawer.darkMode.value = !CustomDrawer.darkMode.value;
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('error'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })
        );
      },
    );
  }
}
