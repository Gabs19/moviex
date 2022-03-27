import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviex/pages/validate_email.dart';

import '../widget/navigationDrawerWidget.dart';

class Restrict extends StatefulWidget {

  @override
  _RestrictState createState() => _RestrictState();
}

class _RestrictState extends State<Restrict>{
  bool isEmailVerified = false;
  Timer? timer;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified) {
      timer = Timer.periodic(
        Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified ?
      ValidateEmail() :
     Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),

      ),
    );
  }

