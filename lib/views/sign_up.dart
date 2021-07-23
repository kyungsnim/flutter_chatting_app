import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/views/chat_rooms_screen.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

class SignUp extends StatefulWidget {
  Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  signUpCheck() {
    if(formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      var userMap = {
        'username': usernameTextEditingController.text,
        'email': emailTextEditingController.text,
      };

      HelperFunctions.saveUsername(usernameTextEditingController.text);
      HelperFunctions.saveEmail(emailTextEditingController.text);

      /// 회원가입에 성공한 경우
      /// 1. DB에 정보 저장
      /// 2. 로그인되었다고 처리
      /// 3. ChatRoomsScreen으로 화면 이동
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        databaseMethods.uploadUserInfo(userMap);
        HelperFunctions.saveLoggedIn(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoomsScreen()));
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
                            return val!.isEmpty || val!.length < 3 ? 'Username is empty or too short' : null;
                          },
                            controller: usernameTextEditingController,
                            style: simpleTextFieldStyle(),
                            decoration: textFieldInputDecoration('username')),
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
                              return val!.isEmpty || val!.length < 6 ? 'Password is empty or too short' : null;
                            },
                            controller: passwordTextEditingController,
                            style: simpleTextFieldStyle(),
                            decoration: textFieldInputDecoration('password')),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      signUpCheck();
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
                          'Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have account? ',
                          style: simpleTextFieldStyle()),
                      InkWell(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Sign In now',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18, color: Colors.white70)),
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
