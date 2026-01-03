import '../Widgets/CustomDrawer.dart';
import '../Widgets/chat_messages.dart';
import '../Widgets/new_messages.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
        Text('ASU CHAT',style: TextStyle(fontWeight: FontWeight.w600),),
      ),
      drawer: CustomDrawer(),
      body: Column(
    children: const [
    Expanded(
    child: ChatMessages(),
    ),
    NewMessage(),], ),
    );
  }
}
