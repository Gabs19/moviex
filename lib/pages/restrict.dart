import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/navigationDrawerWidget.dart';

class Restrict extends StatelessWidget{
  const Restrict({Key? key}) : super(key: key) ;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Perfil'),
      ),
    );
  }

}