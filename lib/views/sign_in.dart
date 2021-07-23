import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/views/chat_rooms_screen.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

class SignIn extends StatefulWidget {
  Function? toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? userInfoSnapshot;

  signInCheck() {
    if(formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByEmail(emailTextEditingController.text)
      .then((val) {
        setState(() {
          userInfoSnapshot = val;
        });
        HelperFunctions.saveEmail(emailTextEditingController.text);
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        if(val != null) {
          HelperFunctions.saveLoggedIn(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoomsScreen()));
        }
      });

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading ? Container(
            child: Center(
                child: CircularProgressIndicator()
            )
        ) : SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            validator: (val) {
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!@#%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ? null : 'Please provide a valid email';
                            },
                            controller: emailTextEditingController,
                            style: simpleTextFieldStyle(),
                            decoration: textFieldInputDecoration('email')),
                        TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val!.isEmpty || val!.length < 3 ? 'Password is empty or too short' : null;
                            },
                            controller: passwordTextEditingController,
                            style: simpleTextFieldStyle(),
                            decoration: textFieldInputDecoration('password')),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Forgot Password?',
                        style: simpleTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      signInCheck();
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.lightBlueAccent,
                            Colors.blueAccent
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  ),
                  SizedBox(height: 10),
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Sign In with Google',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don`t have account? ',
                          style: simpleTextFieldStyle()),
                      InkWell(
                        onTap: () {
                          widget.toggle!();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Register now',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                              color: Colors.white70)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              )),
        ));
  }
}
