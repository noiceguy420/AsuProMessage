import 'package:flutter/material.dart';
import 'home_page.dart';
import 'sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _firebase = FirebaseAuth.instance;
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
class _LoginPageState extends State<LoginPage> {

  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      _form.currentState!.save();
      showDialog(
          context: context,
          builder: (context)=> Center(
            child: CircularProgressIndicator(),
          )
      );
      try {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
       catch (e) {
         showDialog(
             context: context,
             builder: (context)=> Center(
               child: CircularProgressIndicator(),
             )
         );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text( 'Email or Passowrd is incorrect '),
          ),


        );
         Navigator.pop(context);
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child :Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network('https://th.bing.com/th/id/OIP.TalqoWalJWaKbuZgcUEwyAD5D5?rs=1&pid=ImgDetMain',height: 300,width: 300,),
                SizedBox(height: 25,),
                Text('ASU SOCIAL',style: TextStyle(fontSize: 25),),
                SizedBox(height: 35,),
                Form(
                  key: _form,
                child: Column(
                  children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Email',

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }

                    return null;
                  },
                  autocorrect: false,
                  onSaved: (newValue) {
                    _enteredEmail=newValue!;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },

                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",),
                    TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                        },
                        child: Text('Sign up',)
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _submit,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text('Login',),
                    ),
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ],),
            ),
              ],
            ),
          ),
      ),
      ),
    );
  }
}
