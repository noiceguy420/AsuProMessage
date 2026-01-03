
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Widgets/CustomDrawer.dart';
import 'pages/login.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: CustomDrawer.darkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: 'AsuSocial',
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: SafeArea(
            child: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const HomePage();
                  }
                  return const LoginPage();
                }),
          ),
        );
      },
    );
  }
}
