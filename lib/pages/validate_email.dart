import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviex/pages/restrict.dart';

class ValidateEmail extends StatefulWidget {

  @override
  _ValidateEmailState createState() => _ValidateEmailState();

}

class _ValidateEmailState extends State<ValidateEmail>{
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);

    } catch(e) {
      print(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) => isEmailVerified ?
    Restrict()
  :
   Scaffold(
      appBar: AppBar(
        title: Text('Restrict'),
      ),
      body: Container(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  "Email de validação enviado",
                  style: TextStyle(fontSize: 20,),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: sendVerificationEmail,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                            "reenviar Email",
                            style: TextStyle(fontSize: 16)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 150),
      ),
    );
  }
