import 'package:flutter/material.dart';
import 'package:moviex/pages/home.dart';
import 'package:moviex/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../pages/login.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}): super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) return loading();
    else if(auth.usuario == null) return LoginPage();
    else return HomePage();
  }
}

loading() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    )
  );
}