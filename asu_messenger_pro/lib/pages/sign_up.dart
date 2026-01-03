import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController emailController = TextEditingController();
TextEditingController fullNameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class _SignUpState extends State<SignUp> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _FullName = '';
  var _EnterdGPA='';
  var _EnterdAge='';
  var _PassedHours='';
  void SignUpHandler() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;

    _form.currentState!.save();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userCredentials =
      await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': _FullName,
        'email': _enteredEmail,
        'Age': _EnterdAge,
        'GPA': _EnterdGPA,
        'Hours': _PassedHours,
      });

      if (!mounted) return;

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ASU SOCIAL',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Full name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          validator: (value) {
                            if (value == null) {
                              return 'please enter user name';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _FullName = newValue!;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Age',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          validator: (value) {
                            if (value == null) {
                              return 'please Enter your age.';
                            }
                            else if (!(int.tryParse(value)!=null)){
                              return 'please Enter A vaild age';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _EnterdAge = value!;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'GPA',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          validator: (value) {
                            if (value == null) {
                              return 'please Enter your GPA.';
                            }
                            else if(!(double.tryParse(value)!=null)){
                              return 'Enter a Valid GPA.';

                            }
                            return null;
                          },
                          onSaved: (value) {
                            _EnterdGPA = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Hours Passed',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          validator: (value) {
                            if (value == null) {
                              return 'please Enter your Hours Passed.';
                            }
                            else if(!(double.tryParse(value)!=null)){
                              return 'Enter a Valid Hours Passed.';

                            }
                            return null;
                          },
                          onSaved: (value) {
                            _PassedHours = value!;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                          controller: passwordController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null||confirmPasswordController.text!=passwordController.text) {
                              return 'The password is not matches.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  'Log in',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: SignUpHandler,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black45,
                            ),
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}