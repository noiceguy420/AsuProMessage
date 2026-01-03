import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text('Error has Occurred while loading users'),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data == null){
            return const Center(
              child: Text('No data found..'),
            );
          }
          final userData = snapshot.data!.docs;

          return Padding(
            padding: EdgeInsets.all(15),
            child: ListView.separated(
              itemCount: userData.length,
              itemBuilder: (context,index){
                final currentUser = userData[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text(currentUser['username']),
                  subtitle: Text(currentUser['email']),
                  trailing: Icon(Icons.verified,color: Colors.blue,),
                );
              },
              separatorBuilder: (context,index){
                return Divider(
                  thickness: 2,
                );
              },
            ),
          );
        },

      ),
    );
  }
}